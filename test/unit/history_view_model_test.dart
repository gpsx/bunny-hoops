import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bunny_hoops/features/history/view_models/history_view_model.dart';
import 'package:bunny_hoops/data/repositories/thought_repository.dart';
import 'package:bunny_hoops/data/repositories/thought_repository_impl.dart';
import 'package:bunny_hoops/features/tracker/models/thought.dart';

class MockThoughtRepository extends Mock implements ThoughtRepository {}

void main() {
  late MockThoughtRepository mockRepository;

  setUp(() {
    mockRepository = MockThoughtRepository();
  });

  ProviderContainer createContainer(ThoughtRepository repo) {
    final container = ProviderContainer(
      overrides: [
        thoughtRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('HistoryViewModel calculates total thoughts correctly', () async {
    final now = DateTime.now();
    when(() => mockRepository.getThoughts()).thenAnswer((_) async => [
          Thought(id: '1', content: 'c1', createdAt: now),
          Thought(id: '2', content: 'c2', createdAt: now),
        ]);

    final container = createContainer(mockRepository);
    final state = await container.read(historyViewModelProvider.future);

    expect(state.totalThoughts, 2);
  });

  test('HistoryViewModel groups dates correctly', () async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final olderDate = today.subtract(const Duration(days: 5));
    
    when(() => mockRepository.getThoughts()).thenAnswer((_) async => [
          Thought(id: '1', content: 'c1', createdAt: today),
          Thought(id: '2', content: 'c2', createdAt: today),
          Thought(id: '3', content: 'c3', createdAt: yesterday),
          Thought(id: '4', content: 'c4', createdAt: olderDate),
        ]);

    final container = createContainer(mockRepository);
    final state = await container.read(historyViewModelProvider.future);

    expect(state.groupedHistory.length, 3);
    
    // Ordered descending by date
    expect(state.groupedHistory[0].dateLabel, "Hoje");
    expect(state.groupedHistory[0].count, 2);

    expect(state.groupedHistory[1].dateLabel, "Ontem");
    expect(state.groupedHistory[1].count, 1);

    expect(state.groupedHistory[2].count, 1);
    expect(state.groupedHistory[2].dateLabel.contains('de'), isTrue); // e.g. '18 de Out'
  });
}
