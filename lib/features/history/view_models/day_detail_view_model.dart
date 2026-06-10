import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/thought_repository_impl.dart';
import '../../tracker/models/thought.dart';

part 'day_detail_view_model.g.dart';

@riverpod
Future<List<Thought>> dayThoughts(DayThoughtsRef ref, DateTime day) async {
  final repository = ref.read(thoughtRepositoryProvider);
  final thoughts = await repository.getThoughtsForDay(day);
  // Sort chronologically (oldest first → natural chat reading order)
  thoughts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return thoughts;
}
