import 'package:flutter/material.dart';
import '../models/multimodal.dart';
import '../services/multimodal_service.dart';

/// Modal bottom sheet widget for simulating homework photo camera capture, cropping,
/// and submitting extracted OCR problem to Suman AI Teacher.
class HomeworkCameraModal extends StatefulWidget {
  final Function(String scannedText, ImageScanResult scanResult) onHomeworkScanned;

  const HomeworkCameraModal({
    super.key,
    required this.onHomeworkScanned,
  });

  @override
  State<HomeworkCameraModal> createState() => _HomeworkCameraModalState();
}

class _HomeworkCameraModalState extends State<HomeworkCameraModal> {
  final MultiModalService _multimodalService = MultiModalService();
  bool _isProcessing = false;
  String _selectedSubject = 'math';
  ImageScanResult? _scanResult;

  Future<void> _captureAndScanHomework() async {
    setState(() {
      _isProcessing = true;
      _scanResult = null;
    });

    try {
      final payload = ImageScanPayload(
        studentId: 'student_class1_001',
        mimeType: 'image/jpeg',
        subjectHint: _selectedSubject,
        imageBase64: 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
      );

      final result = await _multimodalService.scanHomeworkPhoto(payload);
      setState(() {
        _scanResult = result;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning homework photo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.camera_alt, color: Color(0xFF6750A4)),
                  SizedBox(width: 8),
                  Text(
                    'Homework Photo Scan (OCR)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Subject selector chips
          Row(
            children: [
              const Text('Subject Hint: ', style: TextStyle(fontWeight: FontWeight.w600)),
              ChoiceChip(
                label: const Text('Math'),
                selected: _selectedSubject == 'math',
                onSelected: (val) => setState(() => _selectedSubject = 'math'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('English'),
                selected: _selectedSubject == 'english',
                onSelected: (val) => setState(() => _selectedSubject = 'english'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Camera Preview Box UI
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFF3EDF7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD0BCFF), width: 2),
            ),
            child: _isProcessing
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Analyzing worksheet & stripping PII...'),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.crop_free, size: 48, color: Color(0xFF6750A4)),
                      const SizedBox(height: 8),
                      Text(
                        _scanResult != null
                            ? 'Scanned OCR Text: "${_scanResult!.detectedText.replaceAll('\n', ' ')}"'
                            : 'Align your worksheet problem inside camera preview frame',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: _scanResult != null ? Colors.green.shade800 : Colors.grey.shade700,
                          fontWeight: _scanResult != null ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          if (_scanResult != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8DEF8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detected Homework Type: ${_scanResult!.homeworkType}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Safety Status: ${_scanResult!.safetyStatus} | PII Redacted: ${_scanResult!.piiRedacted}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.psychology),
              label: const Text('Ask Suman Teacher to Solve Step-by-Step'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6750A4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                final scannedText = _scanResult!.detectedText;
                widget.onHomeworkScanned(scannedText, _scanResult!);
                Navigator.pop(context);
              },
            ),
          ] else ...[
            ElevatedButton.icon(
              icon: const Icon(Icons.camera),
              label: const Text('Capture & Extract Math/Text Problem'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6750A4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _captureAndScanHomework,
            ),
          ],
        ],
      ),
    );
  }
}
