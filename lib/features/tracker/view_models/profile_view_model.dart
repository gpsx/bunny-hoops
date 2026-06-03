import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../core/services/notification_service.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  String build() {
    final repository = ref.watch(settingsRepositoryProvider);
    return repository.getActiveProfile();
  }

  Future<void> toggleProfile() async {
    final repository = ref.read(settingsRepositoryProvider);
    final current = state;
    final next = current == 'dado' ? 'coelho' : 'dado';
    await repository.saveActiveProfile(next);
    state = next;

    // Update FCM topic so we listen to the right profile's notifications
    final notificationService = NotificationService();
    await notificationService.updateTopicSubscription(next);
  }
}
