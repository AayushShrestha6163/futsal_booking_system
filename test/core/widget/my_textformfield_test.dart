import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/core/widget/my_textformfield.dart';


void main() {
  testWidgets('MyTextFormField displays label correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MyTextFormField(
            label: 'Email',
          ),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('MyTextFormField allows entering text',
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyTextFormField(
            label: 'Name',
            controller: controller,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Aayush');
    await tester.pump();

    expect(controller.text, 'Aayush');
  });

  testWidgets('MyTextFormField triggers onChanged',
      (WidgetTester tester) async {
    String value = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyTextFormField(
            label: 'Username',
            onChanged: (v) {
              value = v;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'testuser');
    await tester.pump();

    expect(value, 'testuser');
  });

  testWidgets('MyTextFormField validator works',
      (WidgetTester tester) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: MyTextFormField(
              label: 'Password',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Required'), findsOneWidget);
  });
}