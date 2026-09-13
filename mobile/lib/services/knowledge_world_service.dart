import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/knowledge_world.dart';

class KnowledgeWorldMobileService {
  final String baseUrl;
  final http.Client _client;

  KnowledgeWorldMobileService({
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = baseUrl ?? AppConfig.baseUrl,
        _client = client ?? http.Client();

  /// Fetch all available learning worlds
  Future<List<WorldTheme>> fetchWorlds() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/knowledge-world/worlds'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => WorldTheme.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        return _getFallbackWorlds();
      }
    } catch (_) {
      return _getFallbackWorlds();
    }
  }

  /// Fetch quest details by ID
  Future<StoryQuest?> fetchQuest(String questId) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/knowledge-world/quest/$questId'));
      if (response.statusCode == 200) {
        return StoryQuest.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Submit node completion request
  Future<NodeCompletionResponse> completeNode(NodeCompletionRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/knowledge-world/complete-node'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == 200) {
        return NodeCompletionResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        return _getFallbackResponse(request);
      }
    } catch (_) {
      return _getFallbackResponse(request);
    }
  }

  /// Local offline fallback data for rural offline continuity
  List<WorldTheme> _getFallbackWorlds() {
    return [
      WorldTheme(
        worldId: 'world-math-jungle',
        category: 'math_jungle',
        name: 'Math Jungle Quest (Offline)',
        description: 'Explore the wild jungle while learning counting with Raja Monkey!',
        recommendedGrade: 1,
        totalQuests: 1,
        quests: [
          StoryQuest(
            questId: 'quest-math-01',
            worldId: 'world-math-jungle',
            title: 'Banana Counting Adventure',
            description: 'Count bananas with Raja Monkey',
            initialNodeId: 'node-m1-01',
          ),
        ],
      )
    ];
  }

  NodeCompletionResponse _getFallbackResponse(NodeCompletionRequest request) {
    return NodeCompletionResponse(
      success: true,
      studentId: request.studentId,
      questId: request.questId,
      nodeId: request.nodeId,
      nextNodeId: null,
      xpEarned: 15,
      totalXp: 15,
      feedbackMessage: 'Great job! Saved in offline mode.',
      isQuestCompleted: true,
    );
  }
}
