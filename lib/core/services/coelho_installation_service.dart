import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import '../models/profile.dart';

class CoelhoInstallationService {
  CoelhoInstallationService({
    FirebaseAuth? auth,
    FirebaseFunctions? functions,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  Future<bool> announce() async {
    try {
      final user = _auth.currentUser ?? (await _auth.signInAnonymously()).user;
      if (user == null) {
        debugPrint('[BH] installation announcement authentication failed');
        return false;
      }

      await _functions.httpsCallable('broadcastThoughtV1').call(<String, dynamic>{
        'title': 'Amandinha entrou no Bunny hoops 🐰',
        'body': 'Ela instalou e configurou o app.',
        'topic': Profile.coelho.senderTopic,
        'senderProfile': Profile.coelho.storageValue,
      });
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint('[BH] installation announcement authentication failed: $error');
      return false;
    } on FirebaseFunctionsException catch (error) {
      debugPrint('[BH] installation announcement failed: $error');
      return false;
    }
  }
}
