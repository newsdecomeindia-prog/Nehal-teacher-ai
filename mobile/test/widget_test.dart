// This is a basic Flutter widget test for Nehal Ki Teacher AI.

import 'package:flutter_test/flutter_test.dart';

import 'package:nehal_teacher_ai_mobile/main.dart';

void main() {
  testWidgets('Main App loads navigation screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NehalTeacherApp());

    // Verify main screen components render
    expect(find.text('Suman 3D Avatar Teacher'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Study Roadmap'), findsWidgets);
    expect(find.text('English'), findsWidgets);
    expect(find.text('GK Cards'), findsWidgets);
  });
}
