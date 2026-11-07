import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/tracker/models/thought.dart';
import 'thought_repository.dart';

class ThoughtRepositoryImpl implements ThoughtRepository {
  final Box<Thought> _box;
  Future<void> _pendingWrite = Future.value();

  ThoughtRepositoryImpl(this._box);

  @override
  Future<List<Thought>> getThoughts() async {
    return _box.values.toList();
  }

  @override
  Stream<List<Thought>> watchThoughts() async* {
    yield await getThoughts();
    await for (final _ in _box.watch()) {
      yield await getThoughts();
    }
  }

  @override
  Future<void> saveThought(Thought thought) async {
    return _enqueueWrite(() async {
      final existingKey = _box.keys.cast<dynamic>().firstWhere(
            (key) => _box.get(key)?.id == thought.id,
            orElse: () => null,
          );
      if (existingKey != null) {
        await _box.put(existingKey, thought);
        return;
      }

      await _box.add(thought);
    });
  }

  @override
  Future<void> deleteThought(String id) async {
    return _enqueueWrite(() async {
      final key = _box.keys.firstWhere(
        (k) => _box.get(k)?.id == id,
        orElse: () => null,
      );
      if (key != null) {
        await _box.delete(key);
      }
    });
  }

  @override
  Future<int> removeDuplicateThoughts() async {
    var removed = 0;
    await _enqueueWrite(() async {
      final knownIds = <String>{};
      final duplicateKeys = <dynamic>[];

      for (final key in _box.keys) {
        final thought = _box.get(key);
        if (thought != null && !knownIds.add(thought.id)) {
          duplicateKeys.add(key);
        }
      }

      if (duplicateKeys.isNotEmpty) {
        await _box.deleteAll(duplicateKeys);
        removed = duplicateKeys.length;
      }
    });
    return removed;
  }

  Future<void> _enqueueWrite(Future<void> Function() operation) {
    final next = _pendingWrite.then((_) => operation());
    _pendingWrite = next.catchError((_) {});
    return next;
  }

  @override
  Future<int> getSentThoughtCountForDay(DateTime day) async {
    return _box.values.where((thought) {
      return thought.wasSent &&
          thought.createdAt.year == day.year &&
          thought.createdAt.month == day.month &&
          thought.createdAt.day == day.day;
    }).length;
  }

  @override
  Future<int> calculateStreak() async {
    if (_box.isEmpty) return 0;

    final thoughts = _box.values.where((t) => t.wasSent).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    int streak = 0;
    DateTime? lastDate;

    for (var thought in thoughts) {
      final date = DateTime(thought.createdAt.year, thought.createdAt.month,
          thought.createdAt.day);

      if (lastDate == null) {
        // First entry (most recent)
        final today = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        final diff = today.difference(date).inDays;

        if (diff > 1) {
          // Most recent entry is older than yesterday, streak broken
          return 0;
        }
        streak = 1;
        lastDate = date;
      } else {
        final diff = lastDate.difference(date).inDays;
        if (diff == 0) {
          // Same day, ignore
          continue;
        } else if (diff == 1) {
          // Consecutive day
          streak++;
          lastDate = date;
        } else {
          // Gap in days, streak broken
          break;
        }
      }
    }

    return streak;
  }

  @override
  Future<Thought?> getLastEntryToday() async {
    if (_box.isEmpty) return null;

    final now = DateTime.now();
    final todayThoughts = _box.values
        .where((t) =>
            t.createdAt.year == now.year &&
            t.createdAt.month == now.month &&
            t.createdAt.day == now.day &&
            t.wasSent)
        .toList();

    if (todayThoughts.isEmpty) return null;

    return todayThoughts
        .reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
  }

  @override
  Future<List<Thought>> getThoughtsForDay(DateTime day) async {
    return _box.values
        .where(
          (t) =>
              t.createdAt.year == day.year &&
              t.createdAt.month == day.month &&
              t.createdAt.day == day.day,
        )
        .toList();
  }
}

final thoughtRepositoryProvider = Provider<ThoughtRepository>((ref) {
  final box = Hive.box<Thought>('thoughts');
  return ThoughtRepositoryImpl(box);
});
