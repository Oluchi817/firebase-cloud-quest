
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register a new learner.
  Future<UserCredential> register(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Sign in an existing learner.
  Future<UserCredential> signIn(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Sign out the current learner.
  Future<void> logOut() async {
    await _auth.signOut();
  }

  // Return the currently signed-in learner.
  User? get currentUser {
    return _auth.currentUser;
  }
}