import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nehal_teacher_ai_mobile/widgets/homework_camera_widget.dart';
import 'package:nehal_teacher_ai_mobile/widgets/voice_mic_waveform.dart';

void main() {
  group('Multimodal Widgets Test', () {
    testWidgets('HomeworkCameraModal renders subject choices and scan button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeworkCameraModal(
              onHomeworkScanned: (text, result) {},
            ),
          ),
        ),
      );

      expect(find.text('Homework Photo Scan (OCR)'), findsOneWidget);
      expect(find.text('Subject Hint: '), findsOneWidget);
      expect(find.text('Math'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Capture & Extract Math/Text Problem'), findsOneWidget);
    });

    testWidgets('VoiceMicWaveformWidget renders mic button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoiceMicWaveformWidget(
              currentLanguage: 'en',
              onSpeechTranscribed: (text) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.mic_none), findsOneWidget);
    });
  });
}
