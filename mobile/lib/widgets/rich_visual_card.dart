import 'package:flutter/material.dart';

class RichVisualCardData {
  final String entityName;
  final String imageUrl;
  final Map<String, String> titles;
  final String? pronunciationAudio;
  final String simpleExplanation;
  final String checkingQuestion;
  final int classLevel;

  RichVisualCardData({
    required this.entityName,
    required this.imageUrl,
    required this.titles,
    this.pronunciationAudio,
    required this.simpleExplanation,
    required this.checkingQuestion,
    this.classLevel = 1,
  });

  factory RichVisualCardData.fromJson(Map<String, dynamic> json) {
    return RichVisualCardData(
      entityName: json['entity_name'] ?? 'Entity',
      imageUrl: json['image_url'] ?? '',
      titles: Map<String, String>.from(json['titles'] ?? {}),
      pronunciationAudio: json['pronunciation_audio'],
      simpleExplanation: json['simple_explanation'] ?? '',
      checkingQuestion: json['checking_question'] ?? '',
      classLevel: json['class_level'] ?? 1,
    );
  }
}

class RichVisualCardWidget extends StatefulWidget {
  final RichVisualCardData cardData;
  final Function(String)? onAnswerSubmitted;

  const RichVisualCardWidget({
    super.key,
    required this.cardData,
    this.onAnswerSubmitted,
  });

  @override
  State<RichVisualCardWidget> createState() => _RichVisualCardWidgetState();
}

class _RichVisualCardWidgetState extends State<RichVisualCardWidget> {
  bool _isPlayingAudio = false;

  void _playPronunciation() {
    setState(() => _isPlayingAudio = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isPlayingAudio = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.cardData;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8DEF8), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. HD Image Container
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Container(
              height: 180,
              color: Colors.purple.shade50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    data.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.amber.shade100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🇮🇳', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 8),
                            Text(
                              data.entityName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Class ${data.classLevel} Visual',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. 3-Language Names Grid
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFF3EDF7),
            child: Row(
              children: [
                Expanded(
                  child: _buildLangTitle('EN', data.titles['english'] ?? data.entityName),
                ),
                Container(width: 1, height: 28, color: Colors.purple.shade200),
                Expanded(
                  child: _buildLangTitle('HI', data.titles['hindi'] ?? data.entityName),
                ),
                Container(width: 1, height: 28, color: Colors.purple.shade200),
                Expanded(
                  child: _buildLangTitle('MR', data.titles['marathi'] ?? data.entityName),
                ),
              ],
            ),
          ),

          // 3. Audio Pronunciation Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: _playPronunciation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6750A4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(_isPlayingAudio ? Icons.graphic_eq : Icons.volume_up),
              label: Text(_isPlayingAudio ? 'Playing Pronunciation...' : '🔊 Listen Pronunciation'),
            ),
          ),

          // 4. Simple Explanation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              data.simpleExplanation,
              style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
            ),
          ),

          const SizedBox(height: 10),

          // 5. Interactive Suman Checking Question
          if (data.checkingQuestion.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('👩‍🏫', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'Suman Teacher Question:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber.shade900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.checkingQuestion,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      ActionChip(
                        label: const Text('नई दिल्ली (New Delhi)'),
                        backgroundColor: Colors.white,
                        onPressed: () => widget.onAnswerSubmitted?.call('New Delhi'),
                      ),
                      ActionChip(
                        label: const Text('मुंबई (Mumbai)'),
                        backgroundColor: Colors.white,
                        onPressed: () => widget.onAnswerSubmitted?.call('Mumbai'),
                      ),
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLangTitle(String langCode, String title) {
    return Column(
      children: [
        Text(
          langCode,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6750A4)),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }
}
