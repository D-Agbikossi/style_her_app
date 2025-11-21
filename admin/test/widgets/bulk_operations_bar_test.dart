/**
 * Bulk Operations Bar Widget Tests
 * 
 * Tests for the bulk operations bar widget
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:admin/widgets/bulk_operations_bar.dart';

void main() {
  group('BulkOperationsBar', () {
    testWidgets('should not display when no items selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BulkOperationsBar(
              selectedCount: 0,
              onClearSelection: () {},
            ),
          ),
        ),
      );

      // Should not display anything when count is 0
      expect(find.text('0 selected'), findsNothing);
    });

    testWidgets('should display selected count', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BulkOperationsBar(
              selectedCount: 5,
              onClearSelection: () {},
            ),
          ),
        ),
      );

      expect(find.text('5 selected'), findsOneWidget);
    });

    testWidgets('should call onClearSelection when Clear is tapped', (WidgetTester tester) async {
      bool clearCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BulkOperationsBar(
              selectedCount: 3,
              onClearSelection: () {
                clearCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Clear'));
      await tester.pump();

      expect(clearCalled, isTrue);
    });

    testWidgets('should call onBulkDelete when Delete is tapped', (WidgetTester tester) async {
      bool deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BulkOperationsBar(
              selectedCount: 2,
              onClearSelection: () {},
              onBulkDelete: () {
                deleteCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Delete'));
      await tester.pump();

      expect(deleteCalled, isTrue);
    });

    testWidgets('should call onBulkUpdate when Update is tapped', (WidgetTester tester) async {
      bool updateCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BulkOperationsBar(
              selectedCount: 4,
              onClearSelection: () {},
              onBulkUpdate: () {
                updateCalled = true;
              },
              updateLabel: 'Update Status',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Update Status'));
      await tester.pump();

      expect(updateCalled, isTrue);
    });

    testWidgets('should display custom update label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BulkOperationsBar(
              selectedCount: 1,
              onClearSelection: () {},
              onBulkUpdate: () {},
              updateLabel: 'Activate',
            ),
          ),
        ),
      );

      expect(find.text('Activate'), findsOneWidget);
    });
  });
}

