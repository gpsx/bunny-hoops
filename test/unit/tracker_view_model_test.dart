import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bunny_hoops/features/tracker/view_models/tracker_view_model.dart';
import 'package:bunny_hoops/data/repositories/thought_repository.dart';
import 'package:bunny_hoops/data/repositories/thought_repository_impl.dart';
import 'package:bunny_hoops/features/tracker/models/thought.dart';
import 'package:bunny_hoops/data/repositories/settings_repository.dart';
import 'package:bunny_hoops/core/services/notification_service.dart';
import 'package:hive/hive.dart';

class MockThoughtRepository extends Mock implements ThoughtRepository {}
class MockSettingsRepository extends Mock implements SettingsRepository {}
class MockNotificationService extends Mock implements NotificationService {}

class FakeThought extends Fake implements Thought {}

void main() {
  late MockThoughtRepository mockRepository;
  late MockSettingsRepository mockSettingsRepository;
  late MockNotificationService mockNotificationService;
  late ProviderContainer container;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeThought());
    
    Hive.init('.');
    // Register adapter only if needed, but the test might fail if it uses it.
    // Since we just need the box to be open, we can just open it.
    if (!Hive.isBoxOpen('thoughts')) {
      await Hive.openBox<Thought>('thoughts');
    }
    
    const MethodChannel channel = MethodChannel('home_widget');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  });

  setUp(() {
    mockRepository = MockThoughtRepository();
    mockSettingsRepository = MockSettingsRepository();
    mockNotificationService = MockNotificationService();
    
    when(() => mockSettingsRepository.getActiveProfile()).thenReturn('dado');
    when(() => mockNotificationService.showNotification(
      id: any(named: 'id'),
      title: any(named: 'title'),
      body: any(named: 'body'),
    )).thenAnswer((_) async {});
    
    container = ProviderContainer(
      overrides: [
        thoughtRepositoryProvider.overrideWithValue(mockRepository),
        settingsRepositoryProvider.overrideWithValue(mockSettingsRepository),
        notificationServiceProvider.overrideWithValue(mockNotificationService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('recordNewThought increments count and calls save', () async {
    // Initial stats
    when(() => mockRepository.getThoughts()).thenAnswer((_) async => []);
    when(() => mockRepository.getLastEntryToday()).thenAnswer((_) async => null);
    when(() => mockRepository.calculateStreak()).thenAnswer((_) async => 0);
    when(() => mockRepository.saveThought(any())).thenAnswer((_) async => {});

    final viewModel = container.read(trackerViewModelProvider.notifier);
    
    // Wait for init
    await Future.delayed(Duration.zero); 
    
    // Change mock to return 1 thought after saving
    when(() => mockRepository.getThoughts()).thenAnswer((_) async => [
      Thought(id: '1', content: 'test', createdAt: DateTime.now())
    ]);

    await viewModel.recordNewThought();

    verify(() => mockRepository.saveThought(any())).called(1);
    
    final state = await container.read(trackerViewModelProvider.future);
    expect(state, isNotNull);
    expect(state.count, 1);
  });
}
