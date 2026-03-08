import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/features/auth/presentation/pages/signup_screen.dart';
import 'package:futal_booking_system/features/auth/presentation/state/auth_state.dart';
import 'package:futal_booking_system/features/auth/presentation/view_models/auth_viewmodel.dart';

class TestAuthViewModel extends AuthViewModel {
  @override
  AuthState build() {
    return const AuthState();
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {}
}

void main() {
  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(() => TestAuthViewModel()),
      ],
      child: const MaterialApp(
        home: SignupScreen(),
      ),
    );
  }

  Future<void> scrollToSignUp(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.widgetWithText(ElevatedButton, 'Sign Up'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
  }

  group('SignupScreen Widget Test', () {
    testWidgets('should render signup screen UI', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Join and start booking your futsal slots'), findsOneWidget);
      expect(find.text('Personal Info'), findsOneWidget);
      expect(find.text('Your Name'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      await scrollToSignUp(tester);

      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should show validation errors when fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await scrollToSignUp(tester);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pump();

      expect(find.text('Required'), findsNWidgets(2));
      expect(find.text('Email cannot be empty'), findsOneWidget);
      expect(find.text('Password cannot be empty'), findsOneWidget);
      expect(find.text('Confirm Password cannot be empty'), findsOneWidget);
    });

    testWidgets('should show invalid email error',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final firstName = find.widgetWithText(TextFormField, 'First name');
      final lastName = find.widgetWithText(TextFormField, 'Last name');
      final email = find.widgetWithText(TextFormField, 'example@gmail.com');

      await tester.enterText(firstName, 'Aayush');
      await tester.enterText(lastName, 'Shrestha');
      await tester.enterText(email, 'invalidemail');

      await scrollToSignUp(tester);

      final password = find.widgetWithText(TextFormField, 'Create password');
      final confirm = find.widgetWithText(TextFormField, 'Re-enter password');

      await tester.enterText(password, 'password123');
      await tester.enterText(confirm, 'password123');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('should show short password error',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final firstName = find.widgetWithText(TextFormField, 'First name');
      final lastName = find.widgetWithText(TextFormField, 'Last name');
      final email = find.widgetWithText(TextFormField, 'example@gmail.com');

      await tester.enterText(firstName, 'Aayush');
      await tester.enterText(lastName, 'Shrestha');
      await tester.enterText(email, 'aayush@gmail.com');

      await scrollToSignUp(tester);

      final password = find.widgetWithText(TextFormField, 'Create password');
      final confirm = find.widgetWithText(TextFormField, 'Re-enter password');

      await tester.enterText(password, '123');
      await tester.enterText(confirm, '123');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pump();

      expect(find.text('Minimum 6 characters'), findsOneWidget);
    });

    testWidgets('should show password mismatch error',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final firstName = find.widgetWithText(TextFormField, 'First name');
      final lastName = find.widgetWithText(TextFormField, 'Last name');
      final email = find.widgetWithText(TextFormField, 'example@gmail.com');

      await tester.enterText(firstName, 'Aayush');
      await tester.enterText(lastName, 'Shrestha');
      await tester.enterText(email, 'aayush@gmail.com');

      await scrollToSignUp(tester);

      final password = find.widgetWithText(TextFormField, 'Create password');
      final confirm = find.widgetWithText(TextFormField, 'Re-enter password');

      await tester.enterText(password, 'password123');
      await tester.enterText(confirm, 'different123');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should toggle password visibility',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await scrollToSignUp(tester);

      expect(find.byIcon(Icons.visibility), findsWidgets);

      await tester.tap(find.byIcon(Icons.visibility).first);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });
}