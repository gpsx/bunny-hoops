import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/coelho_installation_service.dart';
import '../../../core/models/profile.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Profile build() {
    final repository = ref.watch(settingsRepositoryProvider);
    return repository.getActiveProfile();
  }

  Future<void> toggleProfile() async {
    final repository = ref.read(settingsRepositoryProvider);
    final current = state;
    final next = current == Profile.lontra ? Profile.coelho : Profile.lontra;
    await repository.saveActiveProfile(next);
    state = next;

    // Update FCM topic so we listen to the right profile's notifications
    final notificationService = NotificationService();
    await notificationService.updateTopicSubscription(next);

    if (next == Profile.coelho &&
        !repository.hasAnnouncedCoelhoInstallation()) {
      final announced = await CoelhoInstallationService().announce();
      if (announced) {
        await repository.saveCoelhoInstallationAnnounced();
      }
    }
  }
}
