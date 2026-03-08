import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/features/dashboard/presentation/pages/bottomScreen/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/features/profile/presentation/pages/profile_edit_screen.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'user_username': 'Aayush Shrestha',
      'user_profile_picture': '',
    });

    prefs = await SharedPreferences.getInstance();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: ProfileScreen(),
        ),
      ),
    );
  }

  group('ProfileScreen Widget Test', () {
    testWidgets('should display ProfileEditScreen', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ProfileEditScreen), findsOneWidget);
    });

    testWidgets('should show profile title', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should show username from session', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Aayush Shrestha'), findsOneWidget);
    });

    testWidgets('should show fallback user text when username is empty',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'user_username': '',
        'user_profile_picture': '',
      });

      final emptyPrefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(emptyPrefs),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ProfileScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('User'), findsOneWidget);
    });

    testWidgets('should show edit profile action', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Name, photo'), findsOneWidget);
    });

    testWidgets('should show logout action', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Log out'), findsOneWidget);
      expect(find.text('Sign out from this device'), findsOneWidget);
    });

    testWidgets('should show person icon when no profile image exists',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}