import 'dart:async';
import 'package:flutter/material.dart';
import '../models/analytics.dart';
import '../services/analytics_service.dart';

class ExamModeWidget extends StatefulWidget {
  final String studentId;
  final SubjectCategory subject;
  final int gradeLevel;
  final VoidCallback? onExitExam;

  const ExamModeWidget({
    super.key,
    this.studentId = 'student_class1_001',
    this.subject = SubjectCategory.math,
    this.gradeLevel = 1,
    this.onExitExam,
  });

  @override
  State<ExamModeWidget> createState() => _ExamModeWidgetState();
}

class _ExamModeWidgetState extends State<ExamModeWidget> {
  final AnalyticsService _analyticsService = AnalyticsService();
  ExamPaper? _examPaper;
  bool _isLoading = true;
  bool _isSubmitting = false;

  int _currentQuestionIndex = 0;
  final Map<String, String> _selectedAnswers = {};
  final Map<String, double> _timeSpentPerQuestion = {};

  // Countdown timer
  Timer? _timer;
  int _remainingSeconds = 600; // 10 mins default

  // Evaluation submission result
  ExamSubmissionResponse? _submissionResult;

  @override
  void initState() {
    super.initState();
    _loadExam();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadExam() async {
    setState(() => _isLoading = true);
    try {
      final paper = await _analyticsService.generateExam(
        studentId: widget.studentId,
        gradeLevel: widget.gradeLevel,
        subject: widget.subject,
        examType: ExamType.diagnostic,
        numQuestions: 5,
      );

      if (mounted) {
        setState(() {
          _examPaper = paper;
          _remainingSeconds = paper.durationMinutes * 60;
          _isLoading = false;
        });
        _startTimer();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _submitExam();
      }
    });
  }

  String _formatTimer(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _submitExam() async {
    if (_examPaper == null || _isSubmitting) return;

    _timer?.cancel();
    setState(() => _isSubmitting = true);

    final answers = _examPaper!.questions.map((q) {
      final selected = _selectedAnswers[q.questionId] ?? '';
      return {
        'question_id': q.questionId,
        'answer_text': selected,
        'selected_option_id': selected,
        'time_spent_seconds': _timeSpentPerQuestion[q.questionId] ?? 10.0,
      };
    }).toList();

    try {
      final result = await _analyticsService.submitExam(
        studentId: widget.studentId,
        examId: _examPaper!.examId,
        gradeLevel: widget.gradeLevel,
        subject: widget.subject,
        answers: answers,
      );

      if (mounted) {
        setState(() {
          _submissionResult = result;
          _isSubmitting = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Exam Mode')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_examPaper == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Exam Mode')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load exam paper.'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _loadExam, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (_submissionResult != null) {
      return _buildScoreSummaryView(_submissionResult!);
    }

    final questions = _examPaper!.questions;
    final q = questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FF),
      appBar: AppBar(
        title: Text(_examPaper!.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: _remainingSeconds < 60 ? Colors.red.shade50 : const Color(0xFFF3EDF7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _remainingSeconds < 60 ? Colors.red : const Color(0xFF6750A4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.timer, size: 16, color: _remainingSeconds < 60 ? Colors.red : const Color(0xFF6750A4)),
                const SizedBox(width: 6),
                Text(
                  _formatTimer(_remainingSeconds),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _remainingSeconds < 60 ? Colors.red : const Color(0xFF21005D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Strict Exam Mode Banner (No AI Hints)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.amber.shade100,
            child: const Row(
              children: [
                Icon(Icons.lock, size: 16, color: Colors.brown),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Strict Exam Mode: AI hints disabled during test',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                ),
              ],
            ),
          ),

          // 2. Question Index Header & Palette
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Spacer(),
                Row(
                  children: List.generate(questions.length, (idx) {
                    final isAnswered = _selectedAnswers.containsKey(questions[idx].questionId);
                    final isCurrent = idx == _currentQuestionIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _currentQuestionIndex = idx),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrent
                              ? const Color(0xFF6750A4)
                              : isAnswered
                                  ? Colors.green.shade100
                                  : Colors.grey.shade200,
                          border: Border.all(
                            color: isCurrent ? const Color(0xFF21005D) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${idx + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCurrent ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // 3. Question Card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8DEF8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${q.subject.name.toUpperCase()} • ${q.topic}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6750A4)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        q.questionText,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                      ),
                      const SizedBox(height: 20),

                      // MCQ options
                      if (q.options != null && q.options!.isNotEmpty)
                        ...q.options!.map((opt) {
                          final isSelected = _selectedAnswers[q.questionId] == opt.optionId;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedAnswers[q.questionId] = opt.optionId;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFF3EDF7) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF6750A4) : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                      color: isSelected ? const Color(0xFF6750A4) : Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        opt.text,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                      else
                        // Fill in blank input
                        TextField(
                          onChanged: (val) {
                            setState(() {
                              _selectedAnswers[q.questionId] = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Type your answer here...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. Bottom Navigation Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  OutlinedButton(
                    onPressed: () {
                      setState(() => _currentQuestionIndex--);
                    },
                    child: const Text('Previous'),
                  ),
                const Spacer(),
                if (_currentQuestionIndex < questions.length - 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6750A4)),
                    onPressed: () {
                      setState(() => _currentQuestionIndex++);
                    },
                    child: const Text('Next Question', style: TextStyle(color: Colors.white)),
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: _isSubmitting ? null : _submitExam,
                    child: _isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Submit Exam', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSummaryView(ExamSubmissionResponse res) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FF),
      appBar: AppBar(
        title: const Text('Exam Score Breakdown'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score Banner
            Card(
              elevation: 3,
              color: res.percentage >= 80
                  ? Colors.green.shade50
                  : res.percentage >= 50
                      ? Colors.orange.shade50
                      : Colors.red.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      '${res.percentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: res.percentage >= 80
                            ? Colors.green.shade900
                            : res.percentage >= 50
                                ? Colors.orange.shade900
                                : Colors.red.shade900,
                      ),
                    ),
                    Text(
                      'Score: ${res.totalScore} / ${res.maxScore} Marks',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      res.feedbackMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Suresh AI Analysis Card
            if (res.sureshAnalysis != null)
              Card(
                color: const Color(0xFFFFF8F0),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('👨‍🏫', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Text('Suresh AI Exam Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(res.sureshAnalysis!, style: const TextStyle(fontSize: 13, height: 1.35)),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Strengths and Weaknesses
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🌟 Strengths', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          const SizedBox(height: 6),
                          ...res.strengthAreas.map((s) => Text('• $s', style: const TextStyle(fontSize: 12))),
                          if (res.strengthAreas.isEmpty) const Text('Keep practicing', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🎯 Weak Areas', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                          const SizedBox(height: 6),
                          ...res.weaknessAreas.map((w) => Text('• $w', style: const TextStyle(fontSize: 12))),
                          if (res.weaknessAreas.isEmpty) const Text('None identified', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text('Answer Breakdown', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ...res.questionEvaluations.map((eval) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: eval.isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        eval.isCorrect ? Icons.check : Icons.close,
                        color: eval.isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text('Question ID: ${eval.questionId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Answer: ${eval.studentAnswer}', style: TextStyle(color: eval.isCorrect ? Colors.black87 : Colors.red)),
                        if (!eval.isCorrect) Text('Correct: ${eval.correctAnswer}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        if (eval.explanation != null) Text('Explanation: ${eval.explanation}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    trailing: Text('${eval.pointsAwarded}/${eval.maxPoints} pts', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _submissionResult = null;
                        _currentQuestionIndex = 0;
                        _selectedAnswers.clear();
                      });
                      _loadExam();
                    },
                    child: const Text('Retake Quiz'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6750A4)),
                    onPressed: widget.onExitExam,
                    child: const Text('Back to Dashboard', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
