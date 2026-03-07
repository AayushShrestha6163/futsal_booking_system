import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/features/auth/presentation/pages/forgot_password_page.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: ForgotPasswordPage(),
    );
  }

  group('ForgotPasswordPage Widget Test', () {
    testWidgets('should render forgot password page UI', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Reset your password'), findsOneWidget);
      expect(
        find.text("Enter your email and we’ll send a reset link."),
        findsOneWidget,
      );
      expect(find.text('Email address'), findsOneWidget);
      expect(find.text('Send reset link'), findsOneWidget);
      expect(find.text('Back to login'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should allow entering email in text field', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final emailField = find.byType(TextField);
      expect(emailField, findsOneWidget);

      await tester.enterText(emailField, 'test@gmail.com');
      await tester.pump();

      expect(find.text('test@gmail.com'), findsOneWidget);
    });

    testWidgets('should show snackbar when email is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Send reset link'));
      await tester.pump(); // show snackbar animation start
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should show back to login button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Back to login'), findsOneWidget);
    });

    testWidgets('should have app bar title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Forgot Password'), findsOneWidget);
    });
  });
}