
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChallengeService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, Object?>> loadToday() async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      throw StateError(
        'Sign in before loading your challenge.',
      );
    }

    // Read the shared daily challenge.
    final challengeSnapshot = await _firestore
        .collection('challenges')
        .doc('today')
        .get();

    if (!challengeSnapshot.exists) {
      throw StateError(
        "Today's challenge was not found.",
      );
    }

    // Read only this learner's progress.
    final progressSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('today')
        .get();

    return {
      'challenge': challengeSnapshot.data()!,
      'progress': progressSnapshot.data(),
    };
  }
}