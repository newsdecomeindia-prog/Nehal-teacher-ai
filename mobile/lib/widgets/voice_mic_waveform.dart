import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/multimodal.dart';
import '../services/multimodal_service.dart';

/// Animated Waveform & Mic Button Widget for Voice STT/TTS interaction,
/// with native local on-device Speech Recognition (`speech_to_text`).
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
  final stt.SpeechToText _speech = stt.SpeechToText();

  late AnimationController _animationController;
  bool _isListening = false;
  bool _isProcessing = false;
  bool _speechInitialized = false;
  String _recognizedText = '';
  List<double> _waveformHeights = [10, 20, 15, 30, 25, 12, 18, 28, 14, 22];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _initSpeechRecognizer();
  }

  Future<void> _initSpeechRecognizer() async {
    try {
      bool available = await _speech.initialize(
        onError: (val) {},
        onStatus: (val) {},
      );
      if (mounted) {
        setState(() {
          _speechInitialized = available;
        });
      }
    } catch (_) {
      _speechInitialized = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
      _recognizedText = '';
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

    if (!_speechInitialized) {
      await _initSpeechRecognizer();
    }

    if (_speechInitialized) {
      String localeId = 'en_US';
      if (widget.currentLanguage == 'hi') {
        localeId = 'hi_IN';
      } else if (widget.currentLanguage == 'mr') {
        localeId = 'mr_IN';
      }

      try {
        await _speech.listen(
          onResult: (result) {
            if (mounted) {
              setState(() {
                _recognizedText = result.recognizedWords;
              });
            }
          },
          listenOptions: stt.SpeechListenOptions(
            localeId: localeId,
            listenFor: const Duration(seconds: 30),
            pauseFor: const Duration(seconds: 5),
            partialResults: true,
          ),
        );
      } catch (_) {
        // Fall back gracefully if speech listening fails on platform
      }
    }
  }

  Future<void> _stopListeningAndTranscribe() async {
    _timer?.cancel();
    _animationController.stop();

    try {
      if (_speech.isListening) {
        await _speech.stop();
      }
    } catch (_) {}

    setState(() {
      _isListening = false;
      _isProcessing = true;
    });

    try {
      String finalTranscribedText = _recognizedText.trim();

      // If native local speech engine produced words, use them!
      // Otherwise, fall back to dynamic local standalone STT service handler.
      if (finalTranscribedText.isEmpty) {
        final payload = STTAudioPayload(
          studentId: 'student_class1_001',
          languageHint: widget.currentLanguage,
          audioFormat: 'wav',
        );
        final res = await _multimodalService.transcribeSpeech(payload);
        finalTranscribedText = res.transcribedText;
      }

      setState(() {
        _isProcessing = false;
      });

      widget.onSpeechTranscribed(finalTranscribedText);
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
                  _recognizedText.isNotEmpty
                      ? _recognizedText
                      : (widget.currentLanguage == 'hi'
                          ? 'सुन रहे हैं... बोलिए...'
                          : widget.currentLanguage == 'mr'
                              ? 'ऐकत आहे... बोला...'
                              : 'Listening... Speak now...'),
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
