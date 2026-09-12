// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:nehal_teacher_ai_mobile/main.dart';

void main() {
  testWidgets('Main App loads navigation screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NehalTeacherApp());

    // Verify main screen components render
    expect(find.text('Suman AI Teacher'), findsOneWidget);
    expect(find.text('Knowledge World'), findsWidgets);
    expect(find.text('English Speaking'), findsWidgets);
    expect(find.text('Parent Portal'), findsWidgets);
  });
}
