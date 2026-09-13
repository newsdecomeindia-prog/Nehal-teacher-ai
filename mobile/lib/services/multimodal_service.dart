import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/multimodal.dart';

/// Client service handling multi-modal API interactions for STT, TTS, and Image Scanning.
class MultiModalService {
  final String? _explicitBaseUrl;
  final http.Client client;

  MultiModalService({
    String? baseUrl,
    http.Client? client,
  })  : _explicitBaseUrl = baseUrl,
        client = client ?? http.Client();

  String get baseUrl => _explicitBaseUrl ?? AppConfig.baseUrl;

  /// Transcribe child audio input to text via STT API endpoint.
  Future<STTResponse> transcribeSpeech(STTAudioPayload payload) async {
    final response = await client.post(
      Uri.parse('$baseUrl/multimodal/stt'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload.toJson()),
    );

    if (response.statusCode == 200) {
      return STTResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed speech-to-text transcription: ${response.statusCode} - ${response.body}');
    }
  }

  /// Synthesize teacher explanation text to audio clip via TTS API endpoint.
  Future<TTSResponse> synthesizeSpeech(TTSRequest request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/multimodal/tts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return TTSResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed text-to-speech synthesis: ${response.statusCode} - ${response.body}');
    }
  }

  /// Scan homework/worksheet photo via Image-Scan API endpoint.
  Future<ImageScanResult> scanHomeworkPhoto(ImageScanPayload payload) async {
    final response = await client.post(
      Uri.parse('$baseUrl/multimodal/image-scan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload.toJson()),
    );

    if (response.statusCode == 200) {
      return ImageScanResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed homework photo scan: ${response.statusCode} - ${response.body}');
    }
  }
}
