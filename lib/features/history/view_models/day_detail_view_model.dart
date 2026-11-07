import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/thought_repository_impl.dart';
import '../../../data/providers/thoughts_provider.dart';
import '../../tracker/models/thought.dart';

part 'day_detail_view_model.g.dart';

@riverpod
Future<List<Thought>> dayThoughts(DayThoughtsRef ref, DateTime day) async {
  ref.listen(thoughtsProvider, (_, next) {
    if (next.hasValue) {
      ref.invalidateSelf();
    }
  });
  final repository = ref.read(thoughtRepositoryProvider);
  final thoughtsForDay = await repository.getThoughtsForDay(day);
  // Sort chronologically (oldest first → natural chat reading order)
  thoughtsForDay.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return thoughtsForDay;
}
