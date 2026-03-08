import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:futal_booking_system/widget/my_button.dart';

void main() {
  testWidgets('MyButton displays text correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyButton(
            onPressed: () {}, // FIXED
            text: 'Click Me',
          ),
        ),
      ),
    );

    expect(find.text('Click Me'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('MyButton triggers onPressed when tapped',
      (WidgetTester tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyButton(
            onPressed: () {
              pressed = true;
            },
            text: 'Press',
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(pressed, true);
  });
}