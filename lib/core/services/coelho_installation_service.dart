import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import '../models/profile.dart';

class CoelhoInstallationService {
  CoelhoInstallationService({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  Future<bool> announce() async {
    try {
      await _functions.httpsCallable('broadcastThoughtV1').call(<String, dynamic>{
        'title': 'Amandinha entrou no Bunny hoops 🐰',
        'body': 'Ela instalou e configurou o app.',
        'topic': Profile.coelho.senderTopic,
        'senderProfile': Profile.coelho.storageValue,
      });
      return true;
    } on FirebaseFunctionsException catch (error) {
      debugPrint('[BH] installation announcement failed: $error');
      return false;
    }
  }
}
