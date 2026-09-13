import 'package:flutter/material.dart';
import 'package:nehal_teacher_ai_mobile/config/app_config.dart';
import 'package:nehal_teacher_ai_mobile/models/teacher.dart';
import 'package:nehal_teacher_ai_mobile/services/teacher_service.dart';
import 'package:nehal_teacher_ai_mobile/models/knowledge_world.dart';
import 'package:nehal_teacher_ai_mobile/services/knowledge_world_service.dart';
import 'package:nehal_teacher_ai_mobile/models/english_speaking.dart';
import 'package:nehal_teacher_ai_mobile/services/english_speaking_service.dart';
import 'package:nehal_teacher_ai_mobile/models/analytics.dart';
import 'package:nehal_teacher_ai_mobile/services/analytics_service.dart';
import 'package:nehal_teacher_ai_mobile/widgets/error_boundary.dart';
import 'package:nehal_teacher_ai_mobile/widgets/suman_avatar_header.dart';
import 'package:nehal_teacher_ai_mobile/widgets/rich_visual_card.dart';
import 'package:nehal_teacher_ai_mobile/widgets/homework_camera_widget.dart';
import 'package:nehal_teacher_ai_mobile/widgets/voice_mic_waveform.dart';
import 'package:nehal_teacher_ai_mobile/widgets/parent_dashboard_widget.dart';
import 'package:nehal_teacher_ai_mobile/widgets/exam_mode_widget.dart';

void main() {
  runApp(const NehalTeacherApp());
}

class NehalTeacherApp extends StatelessWidget {
  const NehalTeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MaterialApp(
        title: 'Nehal Ki Teacher AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            primary: const Color(0xFF6750A4),
            secondary: const Color(0xFF006A60),
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    TeacherChatTab(),
    CurriculumWorldTab(),
    EnglishSpeakingTab(),
    KnowledgeWorldGkTab(),
    ParentPortalNavigationWrapper(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Study Roadmap',
          ),
          NavigationDestination(
            icon: Icon(Icons.record_voice_over_outlined),
            selectedIcon: Icon(Icons.record_voice_over),
            label: 'English',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'GK Cards',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Parent Portal',
          ),
        ],
      ),
    );
  }
}

// Wrapper for switching between Parent Dashboard & Exam Mode within Parent Portal Tab
class ParentPortalNavigationWrapper extends StatefulWidget {
  const ParentPortalNavigationWrapper({super.key});

  @override
  State<ParentPortalNavigationWrapper> createState() => _ParentPortalNavigationWrapperState();
}

class _ParentPortalNavigationWrapperState extends State<ParentPortalNavigationWrapper> {
  bool _isExamMode = false;
  SubjectCategory _selectedExamSubject = SubjectCategory.math;

  void _startExam(SubjectCategory subject) {
    setState(() {
      _selectedExamSubject = subject;
      _isExamMode = true;
    });
  }

  void _exitExam() {
    setState(() {
      _isExamMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isExamMode) {
      return ExamModeWidget(
        studentId: 'student_class1_001',
        subject: _selectedExamSubject,
        gradeLevel: 1,
        onExitExam: _exitExam,
      );
    }

    return ParentDashboardWidget(
      onStartExamPressed: _startExam,
    );
  }
}

// ==========================================
// 1. Suman AI Teacher Chat Tab
// ==========================================
class TeacherChatTab extends StatefulWidget {
  const TeacherChatTab({super.key});

  @override
  State<TeacherChatTab> createState() => _TeacherChatTabState();
}

class _TeacherChatTabState extends State<TeacherChatTab> {
  final TeacherService _teacherService = TeacherService();
  final TextEditingController _textController = TextEditingController();
  final List<TeacherChatMessage> _messages = [];
  String _selectedLanguage = 'hi';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialGreeting();
  }

  void _loadInitialGreeting() {
    _messages.add(
      TeacherChatMessage(
        id: '1',
        sender: 'teacher',
        messageText: _selectedLanguage == 'hi'
            ? 'नमस्ते नेहल! मैं सुमन टीचर हूँ। आज क्या सीखोगे?'
            : _selectedLanguage == 'mr'
                ? 'नमस्कार नेहल! मी तुमची सुमन बाई आहे. आज काय शिकूया?'
                : 'Hello Nehal! I am Suman Teacher. What would you like to learn together today?',
        timestamp: DateTime.now(),
      ),
    );
  }

  void _openServerConfigDialog() {
    final serverController = TextEditingController(text: AppConfig.baseUrl);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.settings_ethernet, color: Color(0xFF6750A4)),
            SizedBox(width: 8),
            Text('Backend Server Config', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set the FastAPI backend URL or IP address (e.g. Wi-Fi IP http://192.168.1.5:8000/api/v1 or Android Emulator http://10.0.2.2:8000/api/v1):',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: serverController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Backend URL',
                prefixIcon: Icon(Icons.link),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              AppConfig.resetBaseUrl();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reset backend URL to default: ${AppConfig.baseUrl}')),
              );
            },
            child: const Text('Reset Default'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6750A4),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              AppConfig.setCustomBaseUrl(serverController.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Updated backend URL to: ${AppConfig.baseUrl}')),
              );
            },
            child: const Text('Save & Connect'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage({String? customMessage, bool isConfused = false}) async {
    final text = customMessage ?? _textController.text.trim();
    if (text.isEmpty && !isConfused) return;

    final userMessageText = isConfused ? 'I do not understand this concept.' : text;

    setState(() {
      _messages.add(
        TeacherChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: 'student',
          messageText: userMessageText,
          timestamp: DateTime.now(),
        ),
      );
      if (customMessage == null && !isConfused) _textController.clear();
      _isLoading = true;
    });

    final request = TeacherChatRequest(
      studentId: 'student_class1_001',
      message: userMessageText,
      language: _selectedLanguage,
      isConfused: isConfused,
    );

    final response = await _teacherService.sendChatMessage(request);

    setState(() {
      _isLoading = false;
      _messages.add(
        TeacherChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: 'teacher',
          messageText: response.responseText,
          timestamp: DateTime.now(),
          isFallbackExplanation: response.isFallbackExplanation,
          visualCueTrigger: response.visualCueTrigger,
          richCard: response.richCard,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Suman 3D Avatar Teacher',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF21005D)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF6750A4)),
            tooltip: 'Configure Backend IP / URL',
            onPressed: _openServerConfigDialog,
          ),
          DropdownButton<String>(
            value: _selectedLanguage,
            underline: const SizedBox(),
            onChanged: (String? newLang) {
              if (newLang != null) {
                setState(() {
                  _selectedLanguage = newLang;
                  _messages.clear();
                  _loadInitialGreeting();
                });
              }
            },
            items: const [
              DropdownMenuItem(value: 'en', child: Text('🇬🇧 English')),
              DropdownMenuItem(value: 'hi', child: Text('🇮🇳 हिंदी')),
              DropdownMenuItem(value: 'mr', child: Text('🇮🇳 मराठी')),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SumanAvatarHeader(
                greetingText: _selectedLanguage == 'hi'
                    ? 'नमस्ते नेहल! आज क्या सीखोगे?'
                    : _selectedLanguage == 'mr'
                        ? 'नमस्कार नेहल! आज काय शिकूया?'
                        : 'Hello Nehal! What will you learn today?',
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isTeacher = msg.sender == 'teacher';

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    alignment: isTeacher ? Alignment.centerLeft : Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: isTeacher ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.82,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // Comic speech bubble visual styling (REQ-34): Soft blue for student, bright purple/amber for Suman AI
                            color: isTeacher
                                ? (msg.isFallbackExplanation ? const Color(0xFFFFF3E0) : const Color(0xFFF3EDF7))
                                : const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(22),
                              topRight: const Radius.circular(22),
                              bottomLeft: isTeacher ? const Radius.circular(4) : const Radius.circular(22),
                              bottomRight: isTeacher ? const Radius.circular(22) : const Radius.circular(4),
                            ),
                            border: Border.all(
                              color: isTeacher
                                  ? (msg.isFallbackExplanation ? Colors.orange.shade400 : const Color(0xFF6750A4))
                                  : const Color(0xFF42A5F5),
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isTeacher
                                    ? const Color(0xFF6750A4).withValues(alpha: 0.1)
                                    : Colors.blue.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isTeacher) ...[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF6750A4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Text('👩‍🏫', style: TextStyle(fontSize: 12)),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'Suman AI Teacher 3D',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF21005D),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                              Text(
                                msg.messageText,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.38,
                                  color: isTeacher ? const Color(0xFF1D1B20) : const Color(0xFF0D47A1),
                                  fontWeight: isTeacher ? FontWeight.w500 : FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (msg.richCard != null)
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: RichVisualCardWidget(
                              cardData: msg.richCard!,
                              onAnswerSubmitted: (ans) {
                                _sendMessage(customMessage: 'capital: $ans');
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ActionChip(
                          avatar: const Text('🇮🇳'),
                          label: const Text('PM Modi Card'),
                          backgroundColor: const Color(0xFFF3EDF7),
                          onPressed: () => _sendMessage(customMessage: 'भारत के प्रधानमंत्री कौन हैं?'),
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          avatar: const Text('🧐'),
                          label: const Text('I don\'t understand!'),
                          backgroundColor: Colors.amber.shade100,
                          onPressed: () => _sendMessage(isConfused: true),
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          avatar: const Text('🍎'),
                          label: const Text('Count Apples'),
                          onPressed: () => _sendMessage(customMessage: 'How do I count 5 apples?'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Color(0xFF6750A4)),
                        tooltip: 'Homework Camera Scan',
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => HomeworkCameraModal(
                              onHomeworkScanned: (scannedText, scanResult) {
                                _sendMessage(customMessage: scannedText);
                              },
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: 'Ask Suman Teacher anything...',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      VoiceMicWaveformWidget(
                        currentLanguage: _selectedLanguage,
                        onSpeechTranscribed: (transcribedText) {
                          _sendMessage(customMessage: transcribedText);
                        },
                      ),
                      const SizedBox(width: 4),
                      IconButton.filled(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. Learning Roadmap & Curriculum World Tab
// ==========================================
class CurriculumWorldTab extends StatefulWidget {
  const CurriculumWorldTab({super.key});

  @override
  State<CurriculumWorldTab> createState() => _CurriculumWorldTabState();
}

class _CurriculumWorldTabState extends State<CurriculumWorldTab> {
  final KnowledgeWorldMobileService _kwService = KnowledgeWorldMobileService();
  List<WorldTheme> _worlds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorlds();
  }

  Future<void> _loadWorlds() async {
    final worlds = await _kwService.fetchWorlds();
    setState(() {
      _worlds = worlds;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Progression Roadmap'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadWorlds,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Class 1 Learning Path',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Complete story quests and earn ⭐ stars to unlock next worlds!',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Roadmap Path Layout
                  _buildRoadmapStep('Lesson 1: Numbers 1 to 10', 'Math Jungle', 3, true),
                  _buildRoadmapLine(),
                  _buildRoadmapStep('Lesson 2: Alphabet Phonics', 'Word World', 3, true),
                  _buildRoadmapLine(),
                  _buildRoadmapStep('Lesson 3: Animal Friends', 'Science Safari', 2, false),
                  _buildRoadmapLine(),
                  _buildRoadmapStep('Lesson 4: Famous Leaders (PM Modi)', 'Knowledge World', 0, false),

                  const SizedBox(height: 24),
                  const Text(
                    'Active Story Quests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_worlds.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: Text('No learning worlds available currently.')),
                    )
                  else
                    ..._worlds.map((world) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFE8DEF8),
                            child: Text('🗺️'),
                          ),
                          title: Text(world.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(world.description),
                          trailing: const Chip(
                            label: Text('+150 XP'),
                            backgroundColor: Color(0xFFFFF3E0),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }

  Widget _buildRoadmapStep(String title, String category, int stars, bool isUnlocked) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? const Color(0xFFF3EDF7) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUnlocked ? const Color(0xFF6750A4) : Colors.grey.shade300, width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isUnlocked ? const Color(0xFF6750A4) : Colors.grey,
            child: Icon(isUnlocked ? Icons.check : Icons.lock, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isUnlocked ? Colors.black : Colors.grey)),
                Text(category, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
              ],
            ),
          ),
          Row(
            children: List.generate(
              3,
              (idx) => Icon(
                Icons.star,
                size: 18,
                color: idx < stars ? Colors.amber : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapLine() {
    return Center(
      child: Container(
        width: 4,
        height: 24,
        color: const Color(0xFF6750A4),
      ),
    );
  }
}

// ==========================================
// 3. English Small-Sentence Speaking Engine Tab
// ==========================================
class EnglishSpeakingTab extends StatefulWidget {
  const EnglishSpeakingTab({super.key});

  @override
  State<EnglishSpeakingTab> createState() => _EnglishSpeakingTabState();
}

class _EnglishSpeakingTabState extends State<EnglishSpeakingTab> {
  final EnglishSpeakingService _speakingService = EnglishSpeakingService();
  String _difficulty = 'tier_1';
  bool _isLoadingPrompts = true;
  bool _isRecording = false;
  bool _isEvaluating = false;
  List<SpeakingPrompt> _allPrompts = [];
  SpeakingPrompt? _activePrompt;
  SpeakingEvaluationResponse? _evaluationResult;

  @override
  void initState() {
    super.initState();
    _loadPrompts();
  }

  Future<void> _loadPrompts() async {
    setState(() => _isLoadingPrompts = true);
    try {
      final prompts = await _speakingService.fetchPrompts();
      setState(() {
        _allPrompts = prompts;
        _isLoadingPrompts = false;
        _selectPromptForTier(_difficulty);
      });
    } catch (_) {
      setState(() {
        _isLoadingPrompts = false;
      });
    }
  }

  void _selectPromptForTier(String tier) {
    if (_allPrompts.isEmpty) return;
    final filtered = _allPrompts.where((p) => p.tier == tier).toList();
    setState(() {
      _activePrompt = filtered.isNotEmpty ? filtered.first : _allPrompts.first;
      _evaluationResult = null;
    });
  }

  Future<void> _evaluateSpeechAttempt() async {
    if (_activePrompt == null) return;

    setState(() {
      _isRecording = false;
      _isEvaluating = true;
    });

    try {
      final req = SpeakingEvaluationRequest(
        studentId: 'student_class1_001',
        promptId: _activePrompt!.promptId,
        spokenTranscript: _activePrompt!.targetSentence,
        targetSentence: _activePrompt!.targetSentence,
        durationSeconds: 2.5,
      );

      final res = await _speakingService.evaluateAttempt(req);
      setState(() {
        _evaluationResult = res;
        _isEvaluating = false;
      });
    } catch (e) {
      setState(() {
        _isEvaluating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneticText = _activePrompt?.phonetics.isNotEmpty == true
        ? _activePrompt!.phonetics.first.simplePhonetic
        : 'gud mor-ning tee-cher';
    final targetSentence = _activePrompt?.targetSentence ?? 'Good Morning Teacher!';
    final hindiTranslation = _activePrompt?.translationHindi ?? 'सुप्रभात अध्यापिका जी!';

    return Scaffold(
      appBar: AppBar(
        title: const Text('English Small-Sentence Speaking Engine'),
      ),
      body: _isLoadingPrompts
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'tier_1', label: Text('Tier 1: Greetings')),
                      ButtonSegment(value: 'tier_2', label: Text('Tier 2: Sentences')),
                      ButtonSegment(value: 'tier_3', label: Text('Tier 3: Dialog')),
                    ],
                    selected: {_difficulty},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _difficulty = newSelection.first;
                        _selectPromptForTier(_difficulty);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: const Color(0xFFEADDFF),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            phoneticText,
                            style: TextStyle(color: Colors.purple.shade900, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"$targetSentence"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF21005D),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Chip(
                            avatar: const Icon(Icons.translate, size: 16),
                            label: Text(hindiTranslation),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() => _isRecording = true);
                      },
                      onTapUp: (_) {
                        _evaluateSpeechAttempt();
                      },
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: _isRecording ? Colors.red : const Color(0xFF6750A4),
                        child: _isEvaluating
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Icon(
                                _isRecording ? Icons.mic : Icons.mic_none,
                                size: 48,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isRecording
                        ? 'Listening to child speaking...'
                        : _isEvaluating
                            ? 'Evaluating speech quality...'
                            : 'Press and hold microphone to speak',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _isRecording ? Colors.red : Colors.grey.shade700),
                  ),
                  const SizedBox(height: 24),
                  if (_evaluationResult != null) ...[
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              _evaluationResult!.feedback.encouragementMessage,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildScoreGauge('Fluency', _evaluationResult!.fluency.fluencyScore),
                                _buildScoreGauge('Accuracy', _evaluationResult!.accuracy.overallAccuracy),
                                _buildScoreGauge('Match', _evaluationResult!.accuracy.phoneticMatchPercentage),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Evaluation: Tag [${_evaluationResult!.feedback.feedbackTag}] - ${_evaluationResult!.feedback.starsEarned} Stars Earned!',
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildScoreGauge(String label, double score) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 54,
              height: 54,
              child: CircularProgressIndicator(
                value: (score > 1.0 ? score / 100 : score).clamp(0.0, 1.0),
                strokeWidth: 6,
                backgroundColor: Colors.grey.shade200,
                color: score > 75 || score > 0.75 ? Colors.green : Colors.orange,
              ),
            ),
            Text(
              '${(score > 1.0 ? score : score * 100).toInt()}%',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ==========================================
// 4. Knowledge World (GK Cards & Picture Dictionary) Tab
// ==========================================
class KnowledgeWorldGkTab extends StatefulWidget {
  const KnowledgeWorldGkTab({super.key});

  @override
  State<KnowledgeWorldGkTab> createState() => _KnowledgeWorldGkTabState();
}

class _KnowledgeWorldGkTabState extends State<KnowledgeWorldGkTab> {
  final List<Map<String, dynamic>> _gkCategories = [
    {
      'name': 'Cute Animals',
      'emoji': '🦁',
      'color': Colors.orange.shade100,
      'items': [
        {'en': 'Lion', 'hi': 'शेर', 'mr': 'सिंह', 'sentence': 'Lion is the king of jungle.'},
        {'en': 'Peacock', 'hi': 'मोर', 'mr': 'मोर', 'sentence': 'Peacock is national bird.'},
      ]
    },
    {
      'name': 'Yummy Fruits',
      'emoji': '🍎',
      'color': Colors.red.shade100,
      'items': [
        {'en': 'Apple', 'hi': 'सेब', 'mr': 'सफरचंद', 'sentence': 'I want an apple / मुझे सेब चाहिए'},
        {'en': 'Mango', 'hi': 'आम', 'mr': 'आंबा', 'sentence': 'Mango is king of fruits / आम फलों का राजा है'},
      ]
    },
    {
      'name': 'Fast Vehicles',
      'emoji': '🚗',
      'color': Colors.blue.shade100,
      'items': [
        {'en': 'Car', 'hi': 'कार', 'mr': 'गाडी', 'sentence': 'The car goes fast.'},
        {'en': 'Bus', 'hi': 'बस', 'mr': 'बस', 'sentence': 'School bus is yellow.'},
      ]
    },
    {
      'name': 'Famous People',
      'emoji': '🇮🇳',
      'color': Colors.purple.shade100,
      'items': [
        {'en': 'Narendra Modi', 'hi': 'नरेंद्र मोदी', 'mr': 'नरेंद्र मोदी', 'sentence': 'Prime Minister of India / भारत के प्रधानमंत्री'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge World & Picture Dictionary'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Explore 2D/3D GK Cards',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: _gkCategories.length,
            itemBuilder: (context, index) {
              final cat = _gkCategories[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cat['color'] as Color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cat['emoji'] as String, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text(
                      cat['name'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Multi-Lingual Word Bank & Small Sentences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('💧 Water / पानी / पाणी', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Icon(Icons.volume_up, color: Color(0xFF6750A4)),
                    ],
                  ),
                  const Divider(height: 20),
                  _buildSentenceRow('🇬🇧 EN', 'I want water.'),
                  _buildSentenceRow('🇮🇳 HI', 'मुझे पानी चाहिए।'),
                  _buildSentenceRow('🇮🇳 MR', 'मला पाणी हवे आहे.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentenceRow(String lang, String sentence) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(lang, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 10),
          Expanded(child: Text(sentence, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

// ==========================================
// 5. Parent Portal & Analytics Tab
// ==========================================
class ParentPortalTab extends StatefulWidget {
  const ParentPortalTab({super.key});

  @override
  State<ParentPortalTab> createState() => _ParentPortalTabState();
}

class _ParentPortalTabState extends State<ParentPortalTab> {
  final AnalyticsService _analyticsService = AnalyticsService();
  ParentDashboardResponse? _dashboardData;
  bool _isLoading = true;
  bool _parentalConsentGiven = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final res = await _analyticsService.getParentDashboard(studentId: 'student_class1_001');
      setState(() {
        _dashboardData = res;
        _parentalConsentGiven = res.consentSettings.dpdpConsentGranted;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleConsent(bool val) async {
    setState(() => _parentalConsentGiven = val);
    try {
      final consent = DPDPParentConsent(
        parentId: 'parent-01',
        childStudentId: 'student_class1_001',
        dpdpConsentGranted: val,
        coppaConsentGranted: val,
      );
      await _analyticsService.updateParentConsent(consent);
    } catch (_) {
      // Offline fallback handling already handled by service
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Portal & Diagnostic Analytics'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboard,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    color: Colors.teal.shade50,
                    child: SwitchListTile(
                      value: _parentalConsentGiven,
                      onChanged: _toggleConsent,
                      title: const Text(
                        'DPDP & COPPA Parental Consent Status',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        _parentalConsentGiven
                            ? 'Consent verified for Class 1 learning analytics & AI guidance'
                            : 'Consent revoked (Data minimization active)',
                        style: const TextStyle(fontSize: 12),
                      ),
                      secondary: Icon(
                        _parentalConsentGiven ? Icons.verified_user : Icons.gavel,
                        color: _parentalConsentGiven ? Colors.teal : Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _dashboardData != null ? 'Student: ${_dashboardData!.childName}' : 'Overall Mastery Score',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Chip(
                                label: Text('Class 1 Priority'),
                                backgroundColor: Color(0xFFE8DEF8),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: _dashboardData != null
                                ? (_dashboardData!.overallMasteryPercentage > 1.0
                                    ? _dashboardData!.overallMasteryPercentage / 100
                                    : _dashboardData!.overallMasteryPercentage)
                                : 0.88,
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.teal,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _dashboardData != null
                                ? 'Mastery: ${_dashboardData!.overallMasteryPercentage.toInt()}% across Class 1 foundational skills.'
                                : 'Mastery: 88% across Class 1 foundational skills.',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
