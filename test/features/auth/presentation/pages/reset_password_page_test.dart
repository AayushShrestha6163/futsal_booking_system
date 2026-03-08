import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/features/auth/presentation/pages/reset_password_page.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: ResetPasswordPage(),
    );
  }

 

    testWidgets('should allow entering text into all fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final fields = find.byType(TextField);

      await tester.enterText(fields.at(0), 'abc-token');
      await tester.enterText(fields.at(1), 'password123');
      await tester.enterText(fields.at(2), 'password123');
      await tester.pump();

      expect(find.text('abc-token'), findsOneWidget);
      expect(find.text('password123'), findsNWidgets(2));
    });

    testWidgets('should toggle password visibility icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.visibility).at(0));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should show back button',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Back'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

 
}