import 'package:flutter/material.dart';
import '../models/analytics.dart';
import '../services/analytics_service.dart';

class ParentDashboardWidget extends StatefulWidget {
  final Function(SubjectCategory subject)? onStartExamPressed;

  const ParentDashboardWidget({
    super.key,
    this.onStartExamPressed,
  });

  @override
  State<ParentDashboardWidget> createState() => _ParentDashboardWidgetState();
}

class _ParentDashboardWidgetState extends State<ParentDashboardWidget> {
  final AnalyticsService _analyticsService = AnalyticsService();
  ParentDashboardResponse? _dashboardData;
  bool _isLoading = true;
  bool _dpdpConsent = true;
  bool _voiceProcessingConsent = false;
  int _screenTimeLimitMinutes = 45;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final res = await _analyticsService.getParentDashboard(studentId: 'student_class1_001');
      if (mounted) {
        setState(() {
          _dashboardData = res;
          _dpdpConsent = res.consentSettings.dpdpConsentGranted;
          _voiceProcessingConsent = res.consentSettings.allowVoiceDataProcessing;
          _screenTimeLimitMinutes = res.dailyScreenTimeLimitMinutes;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateConsent({bool? dpdp, bool? voice}) async {
    final updatedDpdp = dpdp ?? _dpdpConsent;
    final updatedVoice = voice ?? _voiceProcessingConsent;

    setState(() {
      _dpdpConsent = updatedDpdp;
      _voiceProcessingConsent = updatedVoice;
    });

    try {
      final consent = DPDPParentConsent(
        parentId: _dashboardData?.parentId ?? 'parent-01',
        childStudentId: 'student_class1_001',
        dpdpConsentGranted: updatedDpdp,
        coppaConsentGranted: updatedDpdp,
        allowVoiceDataProcessing: updatedVoice,
        allowAnalyticsAggregation: true,
        dataRetentionDays: 30,
        consentStatus: updatedDpdp ? ConsentStatus.granted : ConsentStatus.revoked,
      );
      await _analyticsService.updateParentConsent(consent);
    } catch (_) {
      // Handled by service
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = _dashboardData;
    final overallMastery = data?.overallMasteryPercentage ?? 82.5;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: const Text('Parent Dashboard & Analytics'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboard,
            tooltip: 'Refresh Analytics',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. Child Profile Header & Overall Mastery Banner
            _buildOverallMasteryHeader(data, overallMastery),

            const SizedBox(height: 16),

            // Quick Exam Launch Action Banner
            _buildTakeExamBanner(),

            const SizedBox(height: 20),

            // 2. Suresh AI Study Analytics & Insights Card
            _buildSureshAiInsightsCard(data?.sureshAiInsights ?? []),

            const SizedBox(height: 20),

            // 3. Weekly Summary Activity Grid
            _buildWeeklySummaryGrid(data?.weeklySummary),

            const SizedBox(height: 20),

            // 4. Subject Progress Tracking & Accuracy Rates
            _buildSubjectProgressSection(data?.subjectMastery ?? []),

            const SizedBox(height: 20),

            // 5. Active Learning Gaps & Weak Area Identification
            _buildLearningGapsSection(data?.learningGaps ?? []),

            const SizedBox(height: 20),

            // 6. Parental Control Settings & Privacy
            _buildParentalControlsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallMasteryHeader(ParentDashboardResponse? data, double overallMastery) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFE8DEF8),
                  child: Text('👦', style: TextStyle(fontSize: 26)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data != null ? 'Student: ${data.childName}' : 'Student: Nehal',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D1B20)),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Class 1 • Primary Foundational Track',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Text(
                    '${overallMastery.toInt()}% Mastery',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.teal.shade800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (overallMastery / 100.0).clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: Colors.teal.shade50,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderStat('Learning Hours', '${data?.totalLearningHours ?? 12.5} hrs', Icons.access_time),
                _buildHeaderStat('Exams Taken', '${data?.totalExamsTaken ?? 6}', Icons.assignment_turned_in),
                _buildHeaderStat('Active Status', 'On Track ⭐', Icons.stars),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6750A4)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildTakeExamBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6750A4), Color(0xFF7D5260)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white24,
            radius: 22,
            child: Icon(Icons.timer, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exam Mode & Timed Quizzes',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Practice tests without AI hints to measure true mastery.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              if (widget.onStartExamPressed != null) {
                widget.onStartExamPressed!(SubjectCategory.math);
              }
            },
            child: const Text('Start Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSureshAiInsightsCard(List<String> insights) {
    final displayInsights = insights.isNotEmpty
        ? insights
        : [
            'Suresh AI Study Analytics: Child shows 90% accuracy in morning study sessions.',
            'Weak Area Alert: Practice 10 minutes on English Plurals & Pattern Recognition.',
            'Recommendation: Take 1 timed chapter quiz in Math Jungle.',
          ];

    return Card(
      color: const Color(0xFFFFF8F0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange.shade200, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('👨‍🏫', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(
                  'Suresh AI Study Analytics & Insights',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.orange.shade900,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            ...displayInsights.map((insight) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💡 ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text(
                          insight,
                          style: const TextStyle(fontSize: 13, height: 1.35, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummaryGrid(WeeklySummary? summary) {
    final activeDays = summary?.activeDaysCount ?? 5;
    final totalMins = summary?.totalStudyMinutes ?? 180.0;
    final quizzes = summary?.quizzesCompleted ?? 4;
    final avgAccuracy = summary?.averageAccuracyPercentage ?? 88.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Summary Report',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1D1B20)),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.1,
          children: [
            _buildSummaryCard('Active Days', '$activeDays / 7 Days', Icons.calendar_today, Colors.blue),
            _buildSummaryCard('Total Study Time', '${totalMins.toInt()} mins', Icons.timer, Colors.purple),
            _buildSummaryCard('Quizzes Done', '$quizzes Quizzes', Icons.quiz, Colors.green),
            _buildSummaryCard('Avg Accuracy', '${avgAccuracy.toInt()}%', Icons.check_circle, Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectProgressSection(List<SubjectMastery> masteries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subject Progress & Accuracy Tracking',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1D1B20)),
        ),
        const SizedBox(height: 10),
        ...masteries.map((m) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${m.subject.name.toUpperCase()} • ${m.masteryLevel}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          'Accuracy: ${m.accuracyRate.toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: m.accuracyRate >= 80 ? Colors.green : Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (m.scorePercentage / 100.0).clamp(0.0, 1.0),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xFF6750A4),
                      backgroundColor: const Color(0xFFE8DEF8),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time: ${m.timeSpentMinutes.toInt()} mins | Qs: ${m.totalQuestionsAttempted}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        if (widget.onStartExamPressed != null)
                          GestureDetector(
                            onTap: () => widget.onStartExamPressed!(m.subject),
                            child: const Text(
                              'Test Subject →',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6750A4)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildLearningGapsSection(List<LearningGapIndicator> gaps) {
    if (gaps.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weak Area Identification & Learning Gaps',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1D1B20)),
        ),
        const SizedBox(height: 10),
        ...gaps.map((gap) => Card(
              color: Colors.red.shade50,
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${gap.subject.name.toUpperCase()}: ${gap.topic}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(gap.gapDescription, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text('Action: ${gap.recommendedAction}',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade800)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildParentalControlsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.security, color: Color(0xFF6750A4)),
                SizedBox(width: 8),
                Text(
                  'Parental Safety & Privacy Controls',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),

            // DPDP & COPPA Switch
            SwitchListTile(
              value: _dpdpConsent,
              onChanged: (val) => _updateConsent(dpdp: val),
              title: const Text('DPDP Act (India) & COPPA Consent', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              subtitle: const Text('Enables child diagnostic progress analytics with privacy safeguards.', style: TextStyle(fontSize: 12)),
            ),

            // Voice Data Consent Switch
            SwitchListTile(
              value: _voiceProcessingConsent,
              onChanged: (val) => _updateConsent(voice: val),
              title: const Text('Ephemeral Voice Processing Consent', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              subtitle: const Text('Allows Suman Teacher to evaluate spoken audio in-memory without storing raw voice files.', style: TextStyle(fontSize: 12)),
            ),

            const SizedBox(height: 12),
            const Text('Daily Screen Time Limit:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [30, 45, 60, 90].map((mins) {
                final isSelected = _screenTimeLimitMinutes == mins;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text('$mins mins'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _screenTimeLimitMinutes = mins);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
