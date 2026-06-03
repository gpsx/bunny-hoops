import 'package:hive/hive.dart';

part 'thought.g.dart';

@HiveType(typeId: 0)
class Thought extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  final List<String> tags;

  Thought({
    required this.id,
    required this.content,
    required this.createdAt,
    this.tags = const [],
  });

  Thought copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    List<String>? tags,
  }) {
    return Thought(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }
}
