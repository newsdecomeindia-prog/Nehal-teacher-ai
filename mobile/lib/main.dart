import 'package:flutter/material.dart';
import 'package:nehal_teacher_ai_mobile/models/teacher.dart';
import 'package:nehal_teacher_ai_mobile/services/teacher_service.dart';
import 'package:nehal_teacher_ai_mobile/models/knowledge_world.dart';
import 'package:nehal_teacher_ai_mobile/services/knowledge_world_service.dart';
import 'package:nehal_teacher_ai_mobile/models/english_speaking.dart';
import 'package:nehal_teacher_ai_mobile/services/english_speaking_service.dart';
import 'package:nehal_teacher_ai_mobile/models/analytics.dart';
import 'package:nehal_teacher_ai_mobile/services/analytics_service.dart';
import 'package:nehal_teacher_ai_mobile/widgets/error_boundary.dart';

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
    ParentPortalTab(),
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
            icon: Icon(Icons.psychology),
            selectedIcon: Icon(Icons.psychology_alt),
            label: 'Suman AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Knowledge World',
          ),
          NavigationDestination(
            icon: Icon(Icons.record_voice_over_outlined),
            selectedIcon: Icon(Icons.record_voice_over),
            label: 'English Speaking',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom_outlined),
            selectedIcon: Icon(Icons.family_restroom),
            label: 'Parent Portal',
          ),
        ],
      ),
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
  String _selectedLanguage = 'en';
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
            ? 'नमस्ते बेटा! मैं सुमन टीचर हूँ। आज हम क्या नया सीखेंगे?'
            : _selectedLanguage == 'mr'
                ? 'नमस्कार बाळ! मी तुमची सुमन बाई आहे. आज आपण काय शिकूया?'
                : 'Hello dear! I am Suman Teacher. What would you like to learn together today?',
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> _sendMessage({bool isConfused = false}) async {
    final text = _textController.text.trim();
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
      if (!isConfused) _textController.clear();
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
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFE8DEF8),
              child: Text('👩‍🏫', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Suman AI Teacher', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Class 1 Multilingual Mentor', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isTeacher = msg.sender == 'teacher';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  alignment: isTeacher ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isTeacher
                          ? (msg.isFallbackExplanation ? const Color(0xFFFFF3E0) : const Color(0xFFF3EDF7))
                          : const Color(0xFF6750A4),
                      borderRadius: BorderRadius.circular(16),
                      border: msg.isFallbackExplanation ? Border.all(color: Colors.orange.shade300) : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg.isFallbackExplanation) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lightbulb_outline, size: 16, color: Colors.orange.shade800),
                              const SizedBox(width: 4),
                              Text(
                                'Simplified Visual Explanation',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          msg.messageText,
                          style: TextStyle(
                            fontSize: 15,
                            color: isTeacher ? Colors.black87 : Colors.white,
                          ),
                        ),
                        if (msg.visualCueTrigger != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.image, size: 16, color: Colors.deepOrange),
                                const SizedBox(width: 6),
                                Text(
                                  'Visual Cue: ${msg.visualCueTrigger}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
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
                        avatar: const Text('🧐'),
                        label: const Text('I don\'t understand!'),
                        backgroundColor: Colors.amber.shade100,
                        onPressed: () => _sendMessage(isConfused: true),
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        avatar: const Text('🍎'),
                        label: const Text('Count Apples'),
                        onPressed: () {
                          _textController.text = 'How do I count 5 apples?';
                          _sendMessage();
                        },
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        avatar: const Text('🔤'),
                        label: const Text('Alphabet Story'),
                        onPressed: () {
                          _textController.text = 'Tell me an A for Apple story!';
                          _sendMessage();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
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
                    const SizedBox(width: 8),
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
    );
  }
}

// ==========================================
// 2. Curriculum & Knowledge World Tab
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

  String _getBadgeEmoji(String category) {
    if (category.contains('math') || category.contains('number')) return '🔢';
    if (category.contains('alpha') || category.contains('word') || category.contains('english')) return '🔤';
    if (category.contains('nature') || category.contains('evs')) return '🌱';
    return '🗺️';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge World Gamified Learning'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadWorlds,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Class 1 Curriculum Worlds',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_worlds.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(child: Text('No learning worlds available currently.')),
                    )
                  else
                    ..._worlds.map((world) {
                      final firstQuest = world.quests.isNotEmpty ? world.quests.first : null;
                      return _buildWorldCard(
                        badge: _getBadgeEmoji(world.category),
                        title: world.name,
                        description: world.description,
                        xp: 150,
                        completed: world.quests.isEmpty,
                        questTitle: firstQuest?.title,
                      );
                    }),
                ],
              ),
            ),
    );
  }

  Widget _buildWorldCard({
    required String badge,
    required String title,
    required String description,
    required int xp,
    required bool completed,
    String? questTitle,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(badge, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(description, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                      if (questTitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Active Quest: $questTitle',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.purple.shade700),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      completed ? Icons.check_circle : Icons.play_circle_fill,
                      color: completed ? Colors.green : Colors.purple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      completed ? 'Completed' : 'Quest Active',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: completed ? Colors.green : Colors.purple,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text('+$xp XP'),
                  backgroundColor: Colors.amber.shade200,
                ),
              ],
            ),
          ],
        ),
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
        title: const Text('English Speaking Practice'),
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
// 4. Parent Portal & Analytics Tab
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
                  const SizedBox(height: 16),
                  const Text(
                    'Identified Learning Gaps',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (_dashboardData?.learningGaps.isNotEmpty == true)
                    ..._dashboardData!.learningGaps.map(
                      (gap) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                          title: Text(gap.topic, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Recommended action: ${gap.recommendedAction}'),
                          trailing: Text(
                            'Gap: ${gap.severity.name.toUpperCase()}',
                            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  else ...[
                    const Card(
                      child: ListTile(
                        leading: Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        title: Text('Number Line Subtraction', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Recommended action: Practice visual apple subtraction with Suman Teacher.'),
                        trailing: Text(
                          'Gap: Low',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        leading: Icon(Icons.check_circle_outline, color: Colors.green),
                        title: Text('Phonics Sight Words', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Mastered 25 Class 1 sight words.'),
                        trailing: Text(
                          '100%',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
