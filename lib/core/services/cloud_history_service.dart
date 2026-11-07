import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/thought_repository.dart';
import '../../features/tracker/models/thought.dart';

abstract interface class CloudHistorySync {
  Future<void> syncSentThought(Thought thought);
}

class CloudHistoryService implements CloudHistorySync {
  static const _lastSyncKey = 'last_cloud_sync';
  CloudHistoryService({
    required ThoughtRepository repository,
    required SettingsRepository settings,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _repository = repository,
        _settings = settings,
        _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  static const _coupleId = 'bunny-hoops-private';
  final ThoughtRepository _repository;
  final SettingsRepository _settings;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  CollectionReference<Map<String, dynamic>> get _thoughts =>
      _firestore.collection('couples').doc(_coupleId).collection('thoughts');

  Future<void> initialize() async {
    final user = _auth.currentUser ?? (await _auth.signInAnonymously()).user;
    if (user == null) {
      throw StateError(
          'Anonymous Firebase authentication did not return a user.');
    }
    debugPrint('[BH] cloud sync authenticated uid=${user.uid}');
    final duplicateCount = await _repository.removeDuplicateThoughts();
    if (duplicateCount > 0) {
      debugPrint('[BH] cloud sync removed $duplicateCount duplicate thoughts');
    }
    await _backfillLocalThoughts();
    await _settings.saveLastCloudSync(DateTime.now());
    _subscription = _thoughts.snapshots().listen(
      _mergeRemoteThoughts,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('[BH] cloud sync listener failed: $error');
      },
    );
  }

  Future<void> _backfillLocalThoughts() async {
    for (final thought in await _repository.getThoughts()) {
      if (thought.wasSent) await syncSentThought(thought);
    }
  }

  Future<void> syncSentThought(Thought thought) {
    final sender =
        thought.senderProfile ?? _settings.getActiveProfile().storageValue;
    debugPrint('[BH] cloud sync upload thought=${thought.id}');
    return _thoughts.doc(thought.id).set({
      'content': thought.content,
      'createdAt': Timestamp.fromDate(thought.createdAt),
      'imageUrl': thought.imageUrl,
      'senderProfile': sender,
    }, SetOptions(merge: true)).then((_) => _settings.saveLastCloudSync(DateTime.now()));
  }

  Future<void> _mergeRemoteThoughts(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    final profile = _settings.getActiveProfile().storageValue;
    for (final document in snapshot.docs) {
      final data = document.data();
      if (data['senderProfile'] == profile) continue;
      final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
      if (createdAt == null) continue;
      await _repository.saveThought(Thought(
        id: document.id,
        content: data['content'] as String? ?? '',
        createdAt: createdAt,
        isSent: false,
        imageUrl: data['imageUrl'] as String?,
        senderProfile: data['senderProfile'] as String?,
      ));
      debugPrint('[BH] cloud sync imported thought=${document.id}');
    }
  }

  Future<void> dispose() => _subscription?.cancel() ?? Future.value();
}
