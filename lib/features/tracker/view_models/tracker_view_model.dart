import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../data/repositories/thought_repository_impl.dart';
import '../models/thought.dart';

import 'package:image_picker/image_picker.dart';
import '../../../core/services/home_widget_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/notifications/thought_notification_payload.dart';
import '../../../core/services/cloud_history_service.dart';

part 'tracker_view_model.g.dart';

final cloudHistorySyncProvider = Provider<CloudHistorySync>((ref) {
  return CloudHistoryService(
    repository: ref.watch(thoughtRepositoryProvider),
    settings: ref.watch(settingsRepositoryProvider),
  );
});

class TrackerState {
  final int count;
  final int streak;
  final String lastEntry;
  final String? selectedImagePath;
  final bool isLoading;

  TrackerState({
    required this.count,
    required this.streak,
    required this.lastEntry,
    this.selectedImagePath,
    this.isLoading = false,
  });

  TrackerState copyWith({
    int? count,
    int? streak,
    String? lastEntry,
    String? selectedImagePath,
    bool? isLoading,
  }) {
    return TrackerState(
      count: count ?? this.count,
      streak: streak ?? this.streak,
      lastEntry: lastEntry ?? this.lastEntry,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class TrackerViewModel extends _$TrackerViewModel with WidgetsBindingObserver {
  bool _isRecording = false;

  @override
  FutureOr<TrackerState> build() async {
    final subscription = ref
        .read(thoughtRepositoryProvider)
        .watchThoughts()
        .skip(1)
        .listen((_) async {
      state = AsyncData(await _fetchCurrentStats());
    });

    // Also refresh when the app returns from background
    WidgetsBinding.instance.addObserver(this);

    // Clean up subscription and observer when the provider is disposed
    ref.onDispose(() {
      subscription.cancel();
      WidgetsBinding.instance.removeObserver(this);
    });

    final stats = await _fetchCurrentStats();
    await HomeWidgetService.updateData(stats.count);
    return stats;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshStats();
    }
  }

  Future<void> _refreshStats() async {
    final currentState = state.valueOrNull;
    state = const AsyncLoading();
    final newStats = await _fetchCurrentStats();
    state = AsyncData(
        newStats.copyWith(selectedImagePath: currentState?.selectedImagePath));
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      final currentState = state.valueOrNull;
      if (currentState != null) {
        state = AsyncData(
            currentState.copyWith(selectedImagePath: pickedFile.path));
      }
    }
  }

  void removeSelectedImage() {
    final currentState = state.valueOrNull;
    if (currentState != null) {
      // We pass a null specifically, but copyWith ignores nulls unless we do a trick.
      // Let's modify the state directly:
      state = AsyncData(TrackerState(
        count: currentState.count,
        streak: currentState.streak,
        lastEntry: currentState.lastEntry,
        selectedImagePath: null,
        isLoading: currentState.isLoading,
      ));
    }
  }

  Future<void> recordNewThought({String? message}) async {
    if (_isRecording) {
      debugPrint('[BH] ignored duplicate record request');
      return;
    }
    _isRecording = true;

    try {
    final repository = ref.read(thoughtRepositoryProvider);
    final settingsRepo = ref.read(settingsRepositoryProvider);

    const defaultContent = AppStrings.defaultThought;
    final content = (message != null && message.trim().isNotEmpty)
        ? message.trim()
        : defaultContent;

    final thoughtId = DateTime.now().millisecondsSinceEpoch.toString();
    final currentState = state.valueOrNull;
    final imageToUpload = currentState?.selectedImagePath;

    if (currentState != null) {
      state = AsyncData(TrackerState(
        count: currentState.count,
        streak: currentState.streak,
        lastEntry: currentState.lastEntry,
        selectedImagePath: null,
        isLoading: true,
      ));
    }

    String? imageUrl;
    if (imageToUpload != null) {
      final storageService = ref.read(storageServiceProvider);
      imageUrl = await storageService.uploadImage(imageToUpload, thoughtId);
    }

    final newThought = Thought(
      id: thoughtId,
      content: content,
      createdAt: DateTime.now(),
      isSent: true,
      imageUrl: imageUrl,
      senderProfile: settingsRepo.getActiveProfile().storageValue,
    );

    await repository.saveThought(newThought);
    await ref.read(cloudHistorySyncProvider).syncSentThought(newThought);
    final stats = await _fetchCurrentStats();
    state = AsyncData(
        stats); // This naturally clears selectedImagePath because _fetchCurrentStats doesn't include it.
    await HomeWidgetService.updateData(stats.count);

    // Dynamic Notifications logic
    final activeProfile = settingsRepo.getActiveProfile();

    const payloadFactory = ThoughtNotificationPayloadFactory();
    final payload = payloadFactory.create(sender: activeProfile, body: content);

    try {
      debugPrint(
        '[BH] sending as profile=${activeProfile.storageValue} '
        'to topic="${payload.topic}" imageUrl=$imageUrl',
      );
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('broadcastThoughtV1');
      final result = await callable.call(<String, dynamic>{
        'title': payload.title,
        'body': payload.body,
        'topic': payload.topic,
        'thoughtId': newThought.id,
        'senderProfile': activeProfile.storageValue,
        if (imageUrl != null) 'imageUrl': imageUrl,
      });
      debugPrint('[BH] broadcast result: ${result.data}');
    } catch (e) {
      debugPrint("[BH] Failed to broadcast notification: $e");
    } finally {
      final finalState = state.valueOrNull;
      if (finalState != null) {
        state = AsyncData(finalState.copyWith(isLoading: false));
      }
    }
    } finally {
      _isRecording = false;
      final currentState = state.valueOrNull;
      if (currentState != null && currentState.isLoading) {
        state = AsyncData(currentState.copyWith(isLoading: false));
      }
    }
  }

  Future<TrackerState> _fetchCurrentStats() async {
    final repository = ref.read(thoughtRepositoryProvider);

    final now = DateTime.now();
    final todayCount = await repository.getSentThoughtCountForDay(now);

    final lastEntry = await repository.getLastEntryToday();
    String lastEntryStr = "--:--";
    if (lastEntry != null) {
      lastEntryStr =
          "${lastEntry.createdAt.hour.toString().padLeft(2, '0')}:${lastEntry.createdAt.minute.toString().padLeft(2, '0')}";
    }

    final streak = await repository.calculateStreak();

    return TrackerState(
      count: todayCount,
      streak: streak,
      lastEntry: lastEntryStr,
    );
  }
}
