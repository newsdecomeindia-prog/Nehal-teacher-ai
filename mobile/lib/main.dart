import 'package:flutter/material.dart';
import 'package:nehal_teacher_ai_mobile/models/teacher.dart';
import 'package:nehal_teacher_ai_mobile/services/teacher_service.dart';
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
                  color: Colors.black.withOpacity(0.05),
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
class CurriculumWorldTab extends StatelessWidget {
  const CurriculumWorldTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge World Gamified Learning'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Class 1 Curriculum Worlds',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildWorldCard(
            badge: '🔢',
            title: 'Numbers & Counting Forest',
            description: 'Learn numbers 1 to 20, basic addition & subtraction with visual apples.',
            xp: 150,
            completed: true,
          ),
          _buildWorldCard(
            badge: '🔤',
            title: 'Alphabet & Phonics Island',
            description: 'Master letters A to Z, phonics sounds, and simple word formation.',
            xp: 200,
            completed: false,
          ),
          _buildWorldCard(
            badge: '🌱',
            title: 'EVS & Nature Kingdom',
            description: 'Explore plants, animals, seasons, and hygiene habits.',
            xp: 120,
            completed: false,
          ),
        ],
      ),
    );
  }

  Widget _buildWorldCard({
    required String badge,
    required String title,
    required String description,
    required int xp,
    required bool completed,
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
  String _difficulty = 'tier_1';
  bool _isRecording = false;
  bool _showFeedback = false;

  final Map<String, Map<String, String>> _prompts = {
    'tier_1': {
      'sentence': 'Good Morning Teacher!',
      'hindi': 'सुप्रभात अध्यापिका जी!',
      'phonetic': 'gud mor-ning tee-cher',
    },
    'tier_2': {
      'sentence': 'This is a red apple.',
      'hindi': 'यह एक लाल सेब है।',
      'phonetic': 'this iz a red ap-puhl',
    },
    'tier_3': {
      'sentence': 'I love reading books with Suman Teacher.',
      'hindi': 'मुझे सुमन टीचर के साथ किताबें पढ़ना पसंद है।',
      'phonetic': 'ai luhv ree-ding buks',
    },
  };

  @override
  Widget build(BuildContext context) {
    final activePrompt = _prompts[_difficulty]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('English Speaking Practice'),
      ),
      body: SingleChildScrollView(
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
                  _showFeedback = false;
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
                      activePrompt['phonetic']!,
                      style: TextStyle(color: Colors.purple.shade900, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${activePrompt['sentence']!}"',
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
                      label: Text(activePrompt['hindi']!),
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
                  setState(() {
                    _isRecording = false;
                    _showFeedback = true;
                  });
                },
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: _isRecording ? Colors.red : const Color(0xFF6750A4),
                  child: Icon(
                    _isRecording ? Icons.mic : Icons.mic_none,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _isRecording ? 'Listening to child speaking...' : 'Press and hold microphone to speak',
              textAlign: TextAlign.center,
              style: TextStyle(color: _isRecording ? Colors.red : Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            if (_showFeedback) ...[
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        '🌟 Great Effort!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildScoreGauge('Fluency', 92),
                          _buildScoreGauge('Accuracy', 88),
                          _buildScoreGauge('Completeness', 100),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Soft Evaluation: Clear pronunciation and steady pace!',
                        style: TextStyle(fontSize: 14),
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
                value: score / 100,
                strokeWidth: 6,
                backgroundColor: Colors.grey.shade200,
                color: score > 75 ? Colors.green : Colors.orange,
              ),
            ),
            Text('${score.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
  bool _parentalConsentGiven = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Portal & Diagnostic Analytics'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.teal.shade50,
            child: SwitchListTile(
              value: _parentalConsentGiven,
              onChanged: (val) {
                setState(() => _parentalConsentGiven = val);
              },
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overall Mastery Score',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Chip(
                        label: Text('Class 1 Priority'),
                        backgroundColor: Color(0xFFE8DEF8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.88,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mastery: 88% across Class 1 foundational skills.',
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
      ),
    );
  }
}
