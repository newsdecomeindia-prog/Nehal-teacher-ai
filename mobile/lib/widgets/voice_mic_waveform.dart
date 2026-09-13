import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/multimodal.dart';
import '../services/multimodal_service.dart';

/// Animated Waveform & Mic Button Widget for Voice STT/TTS interaction.
class VoiceMicWaveformWidget extends StatefulWidget {
  final String currentLanguage;
  final Function(String transcribedText) onSpeechTranscribed;

  const VoiceMicWaveformWidget({
    super.key,
    required this.currentLanguage,
    required this.onSpeechTranscribed,
  });

  @override
  State<VoiceMicWaveformWidget> createState() => _VoiceMicWaveformWidgetState();
}

class _VoiceMicWaveformWidgetState extends State<VoiceMicWaveformWidget>
    with SingleTickerProviderStateMixin {
  final MultiModalService _multimodalService = MultiModalService();
  late AnimationController _animationController;
  bool _isListening = false;
  bool _isProcessing = false;
  List<double> _waveformHeights = [10, 20, 15, 30, 25, 12, 18, 28, 14, 22];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    _animationController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (mounted && _isListening) {
        setState(() {
          _waveformHeights = List.generate(
            10,
            (_) => Random().nextDouble() * 32 + 8,
          );
        });
      }
    });
  }

  Future<void> _stopListeningAndTranscribe() async {
    _timer?.cancel();
    _animationController.stop();

    setState(() {
      _isListening = false;
      _isProcessing = true;
    });

    try {
      final payload = STTAudioPayload(
        studentId: 'student_class1_001',
        languageHint: widget.currentLanguage,
        audioFormat: 'wav',
      );

      final res = await _multimodalService.transcribeSpeech(payload);

      setState(() {
        _isProcessing = false;
      });

      widget.onSpeechTranscribed(res.transcribedText);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speech transcription error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isListening) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EDF7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF6750A4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mic, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.currentLanguage == 'hi'
                      ? 'सुन रहे हैं... बोलिए...'
                      : widget.currentLanguage == 'mr'
                          ? 'ऐकत आहे... बोला...'
                          : 'Listening... Speak now...',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(width: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _waveformHeights.map((h) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 3.5,
                      height: h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6750A4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
        GestureDetector(
          onTapDown: (_) => _startListening(),
          onTapUp: (_) => _stopListeningAndTranscribe(),
          onTapCancel: () => _stopListeningAndTranscribe(),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: _isListening
                ? Colors.red
                : _isProcessing
                    ? Colors.orange
                    : const Color(0xFF6750A4),
            child: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                    size: 24,
                  ),
          ),
        ),
      ],
    );
  }
}
