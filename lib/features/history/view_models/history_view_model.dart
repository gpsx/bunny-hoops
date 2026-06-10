import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/thought_repository_impl.dart';
import '../../tracker/models/thought.dart';

part 'history_view_model.g.dart';

class DayAggregate {
  final String dateLabel;
  final int count;
  final DateTime date;
  final bool hasMessages;

  DayAggregate({
    required this.dateLabel,
    required this.count,
    required this.date,
    required this.hasMessages,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DayAggregate &&
      other.dateLabel == dateLabel &&
      other.count == count &&
      other.date == date &&
      other.hasMessages == hasMessages;
  }

  @override
  int get hashCode => dateLabel.hashCode ^ count.hashCode ^ date.hashCode;
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

    final totalThoughts = thoughts.where((t) => t.wasSent).length;
    final groupedHistory = _groupThoughtsByDate(thoughts);

    return HistoryState(
      totalThoughts: totalThoughts,
      groupedHistory: groupedHistory,
    );
  }

  List<DayAggregate> _groupThoughtsByDate(List<Thought> thoughts) {
    if (thoughts.isEmpty) return [];

    // Sort descending (most recent first)
    final sortedThoughts = List<Thought>.from(thoughts)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // LinkedHashMap preserves insertion order (most-recent-first)
    final Map<String, ({int count, DateTime date, bool hasMessages})> grouped = {};

    for (var thought in sortedThoughts) {
      final tDate = DateTime(
        thought.createdAt.year,
        thought.createdAt.month,
        thought.createdAt.day,
      );

      String label;
      if (tDate == today) {
        label = 'Today';
      } else if (tDate == yesterday) {
        label = 'Yesterday';
      } else {
        label = _formatDate(tDate);
      }

      final existing = grouped[label];
      grouped[label] = (
        count: (existing?.count ?? 0) + (thought.wasSent ? 1 : 0),
        date: existing?.date ?? tDate,
        // hasMessages = true if any thought in this day has isSent set (new format)
        hasMessages: (existing?.hasMessages ?? false) || (thought.isSent != null),
      );
    }

    return grouped.entries
        .map((e) => DayAggregate(
              dateLabel: e.key,
              count: e.value.count,
              date: e.value.date,
              hasMessages: e.value.hasMessages,
            ))
        .toList();
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
