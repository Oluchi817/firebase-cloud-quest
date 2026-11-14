
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoachService {
  final FirebaseFunctions _functions =
      FirebaseFunctions.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getQuestHint(String question) async {

    if (_auth.currentUser == null) {
      throw StateError('Sign in before using the coach.');
    }

    final trimmed = question.trim();

    if (trimmed.isEmpty) {
      throw ArgumentError('Enter a question first.');
    }

    if (trimmed.length > 300) {
      throw ArgumentError(
        'Your question cannot exceed 300 characters.',
      );
    }

    final callable = _functions.httpsCallable(
      'askQuestCoach',
    );

    final result = await callable.call<Map<String, dynamic>>({
      'question': trimmed,
    });

    final reply = result.data['reply'];

    if (reply is! String || reply.trim().isEmpty) {
      throw StateError('The coach returned an empty response.');
    }

    return reply.trim();
  }
}