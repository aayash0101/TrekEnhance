import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view/register_view.dart';

void main() {
  testWidgets('RegisterView shows Sign Up button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));

    // Check that "Sign Up" text is visible
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('RegisterView shows error when fields are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));

    // Make sure button is visible before tap
    await tester.ensureVisible(find.byKey(const Key('signUpButton')));

    // Tap the Sign Up button
    await tester.tap(find.byKey(const Key('signUpButton')));
    await tester.pump(); // triggers rebuild

    // Since SnackBar shows on screen, pump more to show it
    await tester.pump(const Duration(seconds: 1));

    // Verify snackbar message appears
    expect(find.text('Please fill all the fields'), findsOneWidget);
  });
}
