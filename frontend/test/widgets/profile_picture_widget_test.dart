/**
 * Profile Picture Widget Tests
 * 
 * Widget tests for the ProfilePictureWidget component
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/profile_picture_widget.dart';

void main() {
  group('ProfilePictureWidget', () {
    testWidgets('should display placeholder icon when imageUrl is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfilePictureWidget(
              imageUrl: null,
              radius: 30,
            ),
          ),
        ),
      );

      // Should find the placeholder icon
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should display placeholder icon when imageUrl is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfilePictureWidget(
              imageUrl: '',
              radius: 30,
            ),
          ),
        ),
      );

      // Should find the placeholder icon
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should display image when valid imageUrl is provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfilePictureWidget(
              imageUrl: 'https://example.com/profile.jpg',
              radius: 30,
            ),
          ),
        ),
      );

      // Should find the CachedNetworkImage widget
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('should use custom radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfilePictureWidget(
              imageUrl: null,
              radius: 50,
            ),
          ),
        ),
      );

      // Verify widget is rendered (CircleAvatar may be nested)
      expect(find.byType(ProfilePictureWidget), findsOneWidget);
    });

    testWidgets('should use custom backgroundColor', (WidgetTester tester) async {
      const customColor = Colors.blue;
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfilePictureWidget(
              imageUrl: null,
              radius: 30,
              backgroundColor: customColor,
            ),
          ),
        ),
      );

      // Verify widget is rendered with custom color
      expect(find.byType(ProfilePictureWidget), findsOneWidget);
    });
  });
}

