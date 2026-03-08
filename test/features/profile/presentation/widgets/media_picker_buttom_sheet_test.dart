import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:futal_booking_system/features/profile/presentation/widgets/media_picker_buttom_sheet.dart';

void main() {
  group('MediaPickerBottomSheet Widget Test', () {
    testWidgets('should render camera and gallery options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaPickerBottomSheet(
              onCameraTap: () {},
              onGalleryTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Open Camera'), findsOneWidget);
      expect(find.text('Open Gallery'), findsOneWidget);
      expect(find.byIcon(Icons.camera), findsOneWidget);
      expect(find.byIcon(Icons.browse_gallery), findsOneWidget);
    });

    testWidgets('should call onCameraTap when camera tile is tapped',
        (tester) async {
      var cameraTapped = false;
      var galleryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaPickerBottomSheet(
              onCameraTap: () {
                cameraTapped = true;
              },
              onGalleryTap: () {
                galleryTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Camera'));
      await tester.pump();

      expect(cameraTapped, true);
      expect(galleryTapped, false);
    });

    testWidgets('should call onGalleryTap when gallery tile is tapped',
        (tester) async {
      var cameraTapped = false;
      var galleryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaPickerBottomSheet(
              onCameraTap: () {
                cameraTapped = true;
              },
              onGalleryTap: () {
                galleryTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Gallery'));
      await tester.pump();

      expect(cameraTapped, false);
      expect(galleryTapped, true);
    });

    testWidgets('show() should display bottom sheet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    MediaPickerBottomSheet.show(
                      context,
                      onCameraTap: () {},
                      onGalleryTap: () {},
                    );
                  },
                  child: const Text('Show Bottom Sheet'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Open Camera'), findsOneWidget);
      expect(find.text('Open Gallery'), findsOneWidget);
    });

    testWidgets('show() should close sheet and call onCameraTap',
        (tester) async {
      var cameraTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    MediaPickerBottomSheet.show(
                      context,
                      onCameraTap: () {
                        cameraTapped = true;
                      },
                      onGalleryTap: () {},
                    );
                  },
                  child: const Text('Show Bottom Sheet'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Camera'));
      await tester.pumpAndSettle();

      expect(cameraTapped, true);
      expect(find.text('Open Camera'), findsNothing);
    });

    testWidgets('show() should close sheet and call onGalleryTap',
        (tester) async {
      var galleryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    MediaPickerBottomSheet.show(
                      context,
                      onCameraTap: () {},
                      onGalleryTap: () {
                        galleryTapped = true;
                      },
                    );
                  },
                  child: const Text('Show Bottom Sheet'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Gallery'));
      await tester.pumpAndSettle();

      expect(galleryTapped, true);
      expect(find.text('Open Gallery'), findsNothing);
    });
  });
}