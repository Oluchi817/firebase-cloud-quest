Firebase Cloud Quest

Overview

A Flutter application that uses Firebase services to provide daily challenges, track user progress, award rewards, and offer AI-powered hints.

Technologies

Flutter and Dart

Firebase Authentication

Cloud Firestore

Firebase Cloud Functions

Firebase Emulator Suite

Genkit AI

Features

User sign-up, sign-in, and sign-out

Daily challenge retrieval

Individual progress tracking

Secure points and badge rewards

AI Quest Coach for helpful hints

Firestore security rules

Firestore Structure

challenges/today – Shared daily challenge

users/{uid}/progress/today – Individual user progress

Security

Users can only access their own progress.

Clients cannot directly change progress or rewards.

Cloud Functions handle trusted reward operations.

The AI coach provides hints but cannot award points or badges.

Testing

Tests and checks:

Authentication

Daily challenge retrieval

AI hints and error handling

Challenge completion and rewards

Duplicate completion protection

Firestore security rules

Reflection

Working on this project helped me understand how Flutter and Firebase work together. I learned how Authentication, Firestore, and Cloud Functions support an application. I also learned why security rules are important for protecting user progress and rewards. Building the AI Quest Coach helped me understand how AI can provide helpful hints without controlling important application features. Overall, this project improved my understanding of backend development and application security.

Submission

GitHub: https://github.com/Oluchi817/firebase-cloud-quest
