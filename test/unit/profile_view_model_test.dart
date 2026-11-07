import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bunny_hoops/features/tracker/view_models/profile_view_model.dart';
import 'package:bunny_hoops/data/repositories/settings_repository.dart';
import 'package:bunny_hoops/core/models/profile.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockSettingsRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(Profile.lontra);
  });

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();

    when(() => mockSettingsRepository.getActiveProfile())
        .thenReturn(Profile.lontra);
    when(() => mockSettingsRepository.saveActiveProfile(any()))
        .thenAnswer((_) async {});
    when(() => mockSettingsRepository.hasAnnouncedCoelhoInstallation())
        .thenReturn(true);

    container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(mockSettingsRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('build returns initial profile from settings', () {
    final state = container.read(profileNotifierProvider);
    expect(state, Profile.lontra);
    verify(() => mockSettingsRepository.getActiveProfile()).called(1);
  });

  test('toggleProfile switches profile and saves to repository', () async {
    final notifier = container.read(profileNotifierProvider.notifier);

    await notifier.toggleProfile();

    final state = container.read(profileNotifierProvider);
    expect(state, Profile.coelho);
    verify(() => mockSettingsRepository.saveActiveProfile(Profile.coelho))
        .called(1);

    await notifier.toggleProfile();

    final state2 = container.read(profileNotifierProvider);
    expect(state2, Profile.lontra);
    verify(() => mockSettingsRepository.saveActiveProfile(Profile.lontra))
        .called(1);
  });
}
