
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the selected platform.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Connect to local emulators during debug development.
  if (kDebugMode) {
    FirebaseAuth.instance.useAuthEmulator(
      '10.0.2.2',
      9099,
    );

    FirebaseFirestore.instance.useFirestoreEmulator(
      '10.0.2.2',
      8080,
    );

    FirebaseFunctions.instance.useFunctionsEmulator(
      '10.0.2.2',
      5001,
    );
  }

  runApp(const CloudQuestApp());
}