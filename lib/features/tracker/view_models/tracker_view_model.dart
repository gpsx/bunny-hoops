import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../data/repositories/thought_repository_impl.dart';
import '../models/thought.dart';

import '../../../core/services/home_widget_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/repositories/settings_repository.dart';

part 'tracker_view_model.g.dart';

class TrackerState {
  final int count;
  final int streak;
  final String lastEntry;

  TrackerState({
    required this.count,
    required this.streak,
    required this.lastEntry,
  });

  TrackerState copyWith({
    int? count,
    int? streak,
    String? lastEntry,
  }) {
    return TrackerState(
      count: count ?? this.count,
      streak: streak ?? this.streak,
      lastEntry: lastEntry ?? this.lastEntry,
    );
  }
}

@riverpod
class TrackerViewModel extends _$TrackerViewModel with WidgetsBindingObserver {
  @override
  FutureOr<TrackerState> build() async {
    // Listen for changes in the Hive box to keep the app in sync with the widget
    final box = Hive.box<Thought>('thoughts');
    final subscription = box.watch().listen((_) async {
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
    state = const AsyncLoading();
    state = AsyncData(await _fetchCurrentStats());
  }

  Future<void> recordNewThought({String? message}) async {
    final repository = ref.read(thoughtRepositoryProvider);
    
    final newThought = Thought(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: "Lovely thought",
      createdAt: DateTime.now(),
    );

    await repository.saveThought(newThought);
    final stats = await _fetchCurrentStats();
    state = AsyncData(stats);
    await HomeWidgetService.updateData(stats.count);

    // Dynamic Notifications logic
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final activeProfile = settingsRepo.getActiveProfile();
    
    String title = activeProfile == 'coelho'
        ? "Sarky esta pensando em vc ❤️🦦🤘"
        : "Amandinha esta pensando em vc ❤️🐰🤘";
        
    String body = (message != null && message.trim().isNotEmpty)
        ? message.trim()
        : "Oi meu amor tava pensando em vc agorinha, te amo mt";

    // If I am 'dado' (Sarky/lontra), I send to coelho_thoughts so Amandinha receives.
    // If I am 'coelho' (Amandinha), I send to dado_thoughts so Sarky receives.
    final sendTopic = activeProfile == 'dado' ? 'dado_thoughts' : 'coelho_thoughts';

    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('broadcastThoughtV1');
      await callable.call(<String, dynamic>{
        'title': title,
        'body': body,
        'topic': sendTopic,
      });
    } catch (e) {
      debugPrint("Failed to broadcast notification: $e");
      // Fallback to local notification if Firebase is not yet configured or offline
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.showNotification(
        id: 0,
        title: title,
        body: body,
      );
    }
  }

  Future<TrackerState> _fetchCurrentStats() async {
    final repository = ref.read(thoughtRepositoryProvider);
    final thoughts = await repository.getThoughts();
    
    final now = DateTime.now();
    final todayCount = thoughts.where((t) => 
      t.createdAt.year == now.year && 
      t.createdAt.month == now.month && 
      t.createdAt.day == now.day
    ).length;

    final lastEntry = await repository.getLastEntryToday();
    String lastEntryStr = "--:--";
    if (lastEntry != null) {
      lastEntryStr = "${lastEntry.createdAt.hour.toString().padLeft(2, '0')}:${lastEntry.createdAt.minute.toString().padLeft(2, '0')}";
    }

    final streak = await repository.calculateStreak();

    return TrackerState(
      count: todayCount,
      streak: streak,
      lastEntry: lastEntryStr,
    );
  }
}
