import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/tracker/models/thought.dart';
import 'thought_repository.dart';

class ThoughtRepositoryImpl implements ThoughtRepository {
  final Box<Thought> _box;

  ThoughtRepositoryImpl(this._box);

  @override
  Future<List<Thought>> getThoughts() async {
    return _box.values.toList();
  }

  @override
  Future<void> saveThought(Thought thought) async {
    await _box.add(thought);
  }

  @override
  Future<void> deleteThought(String id) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k)?.id == id,
      orElse: () => null,
    );
    if (key != null) {
      await _box.delete(key);
    }
  }

  @override
  Future<int> calculateStreak() async {
    if (_box.isEmpty) return 0;
    
    final thoughts = _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
    int streak = 0;
    DateTime? lastDate;
    
    for (var thought in thoughts) {
      final date = DateTime(thought.createdAt.year, thought.createdAt.month, thought.createdAt.day);
      
      if (lastDate == null) {
        // First entry (most recent)
        final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
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
    final todayThoughts = _box.values.where((t) => 
      t.createdAt.year == now.year && 
      t.createdAt.month == now.month && 
      t.createdAt.day == now.day
    ).toList();
    
    if (todayThoughts.isEmpty) return null;
    
    return todayThoughts.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
  }
}

final thoughtRepositoryProvider = Provider<ThoughtRepository>((ref) {
  final box = Hive.box<Thought>('thoughts');
  return ThoughtRepositoryImpl(box);
});
