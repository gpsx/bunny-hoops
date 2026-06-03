import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/thought_repository_impl.dart';
import '../../tracker/models/thought.dart';

part 'history_view_model.g.dart';

class DayAggregate {
  final String dateLabel;
  final int count;

  DayAggregate({
    required this.dateLabel,
    required this.count,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DayAggregate &&
      other.dateLabel == dateLabel &&
      other.count == count;
  }

  @override
  int get hashCode => dateLabel.hashCode ^ count.hashCode;
}

class HistoryState {
  final int totalThoughts;
  final List<DayAggregate> groupedHistory;

  HistoryState({
    required this.totalThoughts,
    required this.groupedHistory,
  });

  HistoryState copyWith({
    int? totalThoughts,
    List<DayAggregate>? groupedHistory,
  }) {
    return HistoryState(
      totalThoughts: totalThoughts ?? this.totalThoughts,
      groupedHistory: groupedHistory ?? this.groupedHistory,
    );
  }
}

@riverpod
class HistoryViewModel extends _$HistoryViewModel {
  @override
  FutureOr<HistoryState> build() async {
    return _fetchHistory();
  }

  Future<HistoryState> _fetchHistory() async {
    final repository = ref.read(thoughtRepositoryProvider);
    final thoughts = await repository.getThoughts();

    // 1. Total thoughts calculation
    final totalThoughts = thoughts.length;

    // 2. Date grouping logic
    final groupedHistory = _groupThoughtsByDate(thoughts);

    return HistoryState(
      totalThoughts: totalThoughts,
      groupedHistory: groupedHistory,
    );
  }

  List<DayAggregate> _groupThoughtsByDate(List<Thought> thoughts) {
    if (thoughts.isEmpty) return [];

    // Sort descending by date first
    final sortedThoughts = List<Thought>.from(thoughts)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final Map<String, int> dateCounts = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var thought in sortedThoughts) {
      final tDate = DateTime(thought.createdAt.year, thought.createdAt.month, thought.createdAt.day);
      
      String label;
      if (tDate == today) {
        label = "Today";
      } else if (tDate == yesterday) {
        label = "Yesterday";
      } else {
        label = _formatDate(tDate);
      }

      dateCounts[label] = (dateCounts[label] ?? 0) + 1;
    }

    return dateCounts.entries.map((e) => DayAggregate(dateLabel: e.key, count: e.value)).toList();
  }

  String _formatDate(DateTime date) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = monthNames[date.month - 1];
    return '$month ${date.day}';
  }
}
