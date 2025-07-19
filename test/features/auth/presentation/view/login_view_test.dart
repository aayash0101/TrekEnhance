import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view/login_view.dart';

void main() {


  //widget test for LoginView
  testWidgets('LoginView shows Login button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    // Check that Login text is visible
    expect(find.text('Login'), findsOneWidget);
  });



  //bloc test need adjust 

  testWidgets('LoginView shows error when wrong credentials entered',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    // Enter wrong credentials
    await tester.enterText(find.byType(TextField).at(0), 'wronguser');
    await tester.enterText(find.byType(TextField).at(1), 'wrongpass');

    // Make sure button is visible before tap
    await tester.ensureVisible(find.byKey(const Key('loginButton')));

    // Tap the Login button by Key
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump(); // triggers rebuild after setState

    // Verify error text is displayed
    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
