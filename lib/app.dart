
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/sign_in_screen.dart';
import 'screens/challenge_screen.dart';

class CloudQuestApp extends StatelessWidget {
  final FirebaseAuth? auth;

  const CloudQuestApp({
    super.key,
    this.auth,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = auth ?? FirebaseAuth.instance;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Cloud Quest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final user = snapshot.data;

          if (user == null) {
            return const SignInScreen();
          }

          return ChallengeScreen(user: user);
        },
      ),
    );
  }
}
