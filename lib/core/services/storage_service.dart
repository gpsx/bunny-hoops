import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: 'gs://bunny-hoops.firebasestorage.app');

  /// Uploads an image to Firebase Storage and returns the download URL.
  Future<String?> uploadImage(String filePath, String thoughtId) async {
    final file = File(filePath);
    if (!await file.exists()) return null;

    try {
      final ext = path.extension(filePath);
      final ref = _storage.ref().child('thoughts').child('$thoughtId$ext');
      
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(
          contentType: 'image/${ext.replaceAll('.', '')}',
          customMetadata: {'thoughtId': thoughtId},
        ),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
