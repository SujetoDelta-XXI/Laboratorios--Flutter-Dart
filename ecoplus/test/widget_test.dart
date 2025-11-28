// Widget tests for Finance Tracker app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoplus/main.dart';

void main() {
  testWidgets('App initializes successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the app loads without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
