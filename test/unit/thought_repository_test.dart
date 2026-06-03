import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:bunny_hoops/data/repositories/thought_repository_impl.dart';
import 'package:bunny_hoops/features/tracker/models/thought.dart';

class MockBox extends Mock implements Box<Thought> {}

void main() {
  late MockBox mockBox;
  late ThoughtRepositoryImpl repository;

  setUp(() {
    mockBox = MockBox();
    repository = ThoughtRepositoryImpl(mockBox);
  });

  group('calculateStreak', () {
    test('returns 0 when box is empty', () async {
      when(() => mockBox.isEmpty).thenReturn(true);

      final streak = await repository.calculateStreak();
      expect(streak, 0);
    });

    test('returns 1 when there is only one entry today', () async {
      when(() => mockBox.isEmpty).thenReturn(false);
      when(() => mockBox.values).thenReturn([
        Thought(id: '1', content: 'test', createdAt: DateTime.now()),
      ]);

      final streak = await repository.calculateStreak();
      expect(streak, 1);
    });

    test('returns streak of consecutive days', () async {
      final now = DateTime.now();
      when(() => mockBox.isEmpty).thenReturn(false);
      when(() => mockBox.values).thenReturn([
        Thought(id: '1', content: 'today', createdAt: now),
        Thought(id: '2', content: 'yesterday', createdAt: now.subtract(const Duration(days: 1))),
        Thought(id: '3', content: '2 days ago', createdAt: now.subtract(const Duration(days: 2))),
      ]);

      final streak = await repository.calculateStreak();
      expect(streak, 3);
    });

    test('streak is broken by a gap in days', () async {
      final now = DateTime.now();
      when(() => mockBox.isEmpty).thenReturn(false);
      when(() => mockBox.values).thenReturn([
        Thought(id: '1', content: 'today', createdAt: now),
        Thought(id: '2', content: 'yesterday', createdAt: now.subtract(const Duration(days: 1))),
        Thought(id: '3', content: '3 days ago', createdAt: now.subtract(const Duration(days: 3))), // Gap!
      ]);

      final streak = await repository.calculateStreak();
      expect(streak, 2);
    });
  });
}
