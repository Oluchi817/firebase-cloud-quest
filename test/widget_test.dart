
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:firebase_cloud_quest/app.dart';

void main() {
  testWidgets('Cloud Quest app loads', (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuth(
      signedIn: false,
    );

    await tester.pumpWidget(
      CloudQuestApp(auth: mockAuth),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CloudQuestApp), findsOneWidget);
  });
}
