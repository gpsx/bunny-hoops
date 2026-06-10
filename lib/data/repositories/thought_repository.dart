import '../../features/tracker/models/thought.dart';

abstract class ThoughtRepository {
  Future<List<Thought>> getThoughts();
  Future<void> saveThought(Thought thought);
  Future<void> deleteThought(String id);
  Future<int> calculateStreak();
  Future<Thought?> getLastEntryToday();
  Future<List<Thought>> getThoughtsForDay(DateTime day);
}
