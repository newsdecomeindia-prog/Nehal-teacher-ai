import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nehal_teacher_ai_mobile/main.dart';
import 'package:nehal_teacher_ai_mobile/widgets/parent_dashboard_widget.dart';
import 'package:nehal_teacher_ai_mobile/widgets/exam_mode_widget.dart';

void main() {
  group('Parent Dashboard & Exam Mode Widget Tests', () {
    testWidgets('ParentDashboardWidget renders analytics and safety controls',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParentDashboardWidget(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Parent Dashboard & Analytics'), findsOneWidget);
      expect(find.textContaining('Mastery'), findsWidgets);
      expect(find.text('Suresh AI Study Analytics & Insights'), findsOneWidget);
      expect(find.text('Weekly Summary Report'), findsOneWidget);
      expect(find.text('Subject Progress & Accuracy Tracking'), findsOneWidget);
      expect(find.text('Parental Safety & Privacy Controls'), findsOneWidget);
      expect(find.text('DPDP Act (India) & COPPA Consent'), findsOneWidget);
    });

    testWidgets('ExamModeWidget renders strict test interface and timer',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExamModeWidget(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Strict Exam Mode: AI hints disabled'), findsOneWidget);
      expect(find.textContaining('Question 1 of'), findsOneWidget);
      expect(find.textContaining('What is 3 + 4?'), findsOneWidget);
      expect(find.byIcon(Icons.timer), findsOneWidget);
    });

    testWidgets('ParentPortalNavigationWrapper toggles to Exam Mode on quiz tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParentPortalNavigationWrapper(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Parent Dashboard & Analytics'), findsOneWidget);

      // Tap 'Start Quiz' button
      final startQuizBtn = find.text('Start Quiz');
      expect(startQuizBtn, findsOneWidget);
      await tester.tap(startQuizBtn);
      await tester.pumpAndSettle();

      // Verify we switched to ExamModeWidget
      expect(find.textContaining('Strict Exam Mode: AI hints disabled'), findsOneWidget);
    });
  });
}
