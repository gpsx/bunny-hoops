import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import '../../data/repositories/thought_repository.dart';
import '../../features/tracker/models/thought.dart';

class HistoryExportService {
  const HistoryExportService(this._repository);

  final ThoughtRepository _repository;

  Future<void> shareExport() async {
    final thoughts = await _repository.getThoughts();
    final export = {
      'formatVersion': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'thoughts': thoughts
          .map(
            (thought) => {
              'id': thought.id,
              'content': thought.content,
              'createdAt': thought.createdAt.toIso8601String(),
              'isSent': thought.isSent,
              'imageUrl': thought.imageUrl,
              'senderProfile': thought.senderProfile,
            },
          )
          .toList(),
    };
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}${Platform.pathSeparator}bunny-hoops-history-${DateTime.now().millisecondsSinceEpoch}.json',
    );
    await file.writeAsString(jsonEncode(export));
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Bunny Hoops history backup',
      ),
    );
  }

  Future<int> importBackup() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (files.isEmpty) return 0;
    final path = files.single.path;
    if (path == null) throw const FormatException('Arquivo de backup indisponível.');
    final backup = jsonDecode(await File(path).readAsString()) as Map<String, dynamic>;
    if (backup['formatVersion'] != 1 || backup['thoughts'] is! List) {
      throw const FormatException('Formato de backup não suportado.');
    }
    var imported = 0;
    for (final item in backup['thoughts'] as List) {
      final data = item as Map<String, dynamic>;
      await _repository.saveThought(Thought(
        id: data['id'] as String,
        content: data['content'] as String,
        createdAt: DateTime.parse(data['createdAt'] as String),
        isSent: data['isSent'] as bool?,
        imageUrl: data['imageUrl'] as String?,
        senderProfile: data['senderProfile'] as String?,
      ));
      imported++;
    }
    return imported;
  }
}
