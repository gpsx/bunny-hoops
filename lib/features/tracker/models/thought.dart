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
  @HiveField(4)
  final bool? isSent;
  @HiveField(5)
  final String? imageUrl;

  Thought({
    required this.id,
    required this.content,
    required this.createdAt,
    this.tags = const [],
    this.isSent,
    this.imageUrl,
  });

  /// Old records (isSent == null) are treated as sent.
  bool get wasSent => isSent ?? true;

  Thought copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    List<String>? tags,
    bool? isSent,
    String? imageUrl,
  }) {
    return Thought(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      isSent: isSent ?? this.isSent,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

