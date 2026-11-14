
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardService {
  final FirebaseFunctions _functions =
      FirebaseFunctions.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> completeChallenge() async {
    if (_auth.currentUser == null) {
      throw StateError('You must sign in first.');
    }

    final callable = _functions.httpsCallable(
      'completeToday',
    );

    final result = await callable.call<Map<String, dynamic>>({
      'challengeId': 'today',
    });

    return Map<String, dynamic>.from(result.data);
  }
}