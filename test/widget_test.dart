// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swn_race_timer/race_app.dart';

void main() {
  testWidgets('Add Racer test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RaceApp());

    // Verify that our counter starts at 0.
    expect(find.text('Individual'), findsOneWidget);
    expect(find.text('Group'), findsOneWidget);
    expect(find.text('Mass'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that our counter has incremented.
    expect(find.text("Racer's Name"), findsOneWidget);
    expect(find.text("Bib Number"), findsOneWidget);
  });
}
