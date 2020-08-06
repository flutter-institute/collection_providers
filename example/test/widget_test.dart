// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart' as example;

void main() {
  Future addItem(WidgetTester tester, String name) async {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Input the text and clik the save button
    await tester.enterText(find.byType(TextField), name);
    await tester.tap(find.byType(RaisedButton));
    await tester.pumpAndSettle();
  }

  testWidgets('List adds items', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    example.main();

    // Verify initial items
    expect(find.text('Item[0] = list 1'), findsOneWidget);
    expect(find.text('Item[1] = list 2'), findsOneWidget);
    expect(find.text('Item[2] = list 3'), findsOneWidget);

    // Add an item
    await addItem(tester, 'list test');

    // Verify that our text updated
    expect(find.text('Item[3] = list test'), findsOneWidget);
  });

  testWidgets('Set adds items', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    example.main();

    // Switch to Set
    await tester.tap(find.text('Set'));
    await tester.pump();

    // Verify initial items
    expect(find.text('Item[0] = set 1'), findsOneWidget);
    expect(find.text('Item[1] = set 2'), findsOneWidget);
    expect(find.text('Item[2] = set 3'), findsOneWidget);

    // Add an item
    await addItem(tester, 'set test');

    // Verify that our text updated
    expect(find.text('Item[3] = set test'), findsOneWidget);
  });

  testWidgets('Map adds items', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    example.main();

    // Switch to Set
    await tester.tap(find.text('Map'));
    await tester.pump();

    // Verify initial items
    expect(find.text('Item[map 1] = 1'), findsOneWidget);
    expect(find.text('Item[map 2] = 2'), findsOneWidget);
    expect(find.text('Item[map 3] = 3'), findsOneWidget);

    // Add an item
    await addItem(tester, 'map test');

    // Verify that our text updated
    expect(find.text('Item[map test] = 4'), findsOneWidget);
  });
}
