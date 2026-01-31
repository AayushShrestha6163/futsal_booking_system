import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/features/auth/presentation/pages/login_screen.dart';
import 'package:futal_booking_system/features/auth/presentation/pages/signup_screen.dart';

Widget makeTestable(Widget child) {
  return ProviderScope(child: MaterialApp(home: child));
}

void main() {
  testWidgets('renders texts, fields and buttons', (tester) async {
    await tester.pumpWidget(makeTestable(const LoginScreen()));

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Login Account'), findsWidgets);

    expect(find.text('Email Address :'), findsOneWidget);
    expect(find.text('Password :'), findsOneWidget);

    expect(find.text('Login Account'), findsWidgets);
    expect(find.text('Create New Account'), findsOneWidget);
  });

  testWidgets('shows email validation error for invalid email', (tester) async {
    await tester.pumpWidget(makeTestable(const LoginScreen()));

    final emailField = find.byType(TextFormField).first;

    // Enter invalid email
    await tester.enterText(emailField, 'invalid-email');

    // Tap login button (use ElevatedButton to avoid ambiguity with header text)
    final loginBtn = find.widgetWithText(ElevatedButton, 'Login Account');
    await tester.tap(loginBtn);
    await tester.pump();

    expect(find.text('Enter a valid email must be @gmail.com'), findsOneWidget);
  });

  testWidgets('shows password validation error when empty', (tester) async {
    await tester.pumpWidget(makeTestable(const LoginScreen()));

    // Make sure email is valid so password validator triggers
    final emailField = find.byType(TextFormField).first;
    await tester.enterText(emailField, 'user@example.com');

    final loginBtn = find.widgetWithText(ElevatedButton, 'Login Account');
    await tester.tap(loginBtn);
    await tester.pump();

    expect(find.text('Password cannot be empty'), findsOneWidget);
  });

  testWidgets('toggles obscure password when suffix icon tapped', (
    tester,
  ) async {
    await tester.pumpWidget(makeTestable(const LoginScreen()));

    // Initially lock_outline should be present
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);

    // Tap the icon to toggle
    await tester.tap(find.byIcon(Icons.lock_outline));
    await tester.pump();

    expect(find.byIcon(Icons.lock_open), findsOneWidget);
  });

  testWidgets('navigates to SignupScreen when Create New Account tapped', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2400));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(makeTestable(const LoginScreen()));

    await tester.tap(find.text('Create New Account'));
    await tester.pumpAndSettle();

    expect(find.byType(SignupScreen), findsOneWidget);
  });
}
