/// Knowledge World Flutter Models for Gamified Quests & Story Progression
library;

class ChoiceOption {
  final String choiceId;
  final String text;
  final bool isCorrect;
  final String? explanation;
  final String? nextNodeId;
  final int xpReward;

  ChoiceOption({
    required this.choiceId,
    required this.text,
    this.isCorrect = true,
    this.explanation,
    this.nextNodeId,
    this.xpReward = 10,
  });

  factory ChoiceOption.fromJson(Map<String, dynamic> json) {
    return ChoiceOption(
      choiceId: json['choice_id'] as String,
      text: json['text'] as String,
      isCorrect: json['is_correct'] as bool? ?? true,
      explanation: json['explanation'] as String?,
      nextNodeId: json['next_node_id'] as String?,
      xpReward: json['xp_reward'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
        'choice_id': choiceId,
        'text': text,
        'is_correct': isCorrect,
        'explanation': explanation,
        'next_node_id': nextNodeId,
        'xp_reward': xpReward,
      };
}

class QuestNode {
  final String nodeId;
  final String questId;
  final String title;
  final String storyPrompt;
  final String? dialogueSpeaker;
  final List<ChoiceOption> choiceOptions;
  final String? mediaAssetUrl;
  final int targetGrade;

  QuestNode({
    required this.nodeId,
    required this.questId,
    required this.title,
    required this.storyPrompt,
    this.dialogueSpeaker,
    this.choiceOptions = const [],
    this.mediaAssetUrl,
    this.targetGrade = 1,
  });

  factory QuestNode.fromJson(Map<String, dynamic> json) {
    return QuestNode(
      nodeId: json['node_id'] as String,
      questId: json['quest_id'] as String,
      title: json['title'] as String,
      storyPrompt: json['story_prompt'] as String,
      dialogueSpeaker: json['dialogue_speaker'] as String?,
      choiceOptions: (json['choice_options'] as List<dynamic>?)
              ?.map((e) => ChoiceOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mediaAssetUrl: json['media_asset_url'] as String?,
      targetGrade: json['target_grade'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'node_id': nodeId,
        'quest_id': questId,
        'title': title,
        'story_prompt': storyPrompt,
        'dialogue_speaker': dialogueSpeaker,
        'choice_options': choiceOptions.map((e) => e.toJson()).toList(),
        'media_asset_url': mediaAssetUrl,
        'target_grade': targetGrade,
      };
}

class StoryQuest {
  final String questId;
  final String worldId;
  final String title;
  final String description;
  final int gradeLevel;
  final int totalNodes;
  final String initialNodeId;
  final List<QuestNode> nodes;

  StoryQuest({
    required this.questId,
    required this.worldId,
    required this.title,
    required this.description,
    this.gradeLevel = 1,
    this.totalNodes = 1,
    required this.initialNodeId,
    this.nodes = const [],
  });

  factory StoryQuest.fromJson(Map<String, dynamic> json) {
    return StoryQuest(
      questId: json['quest_id'] as String,
      worldId: json['world_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      gradeLevel: json['grade_level'] as int? ?? 1,
      totalNodes: json['total_nodes'] as int? ?? 1,
      initialNodeId: json['initial_node_id'] as String,
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((e) => QuestNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'quest_id': questId,
        'world_id': worldId,
        'title': title,
        'description': description,
        'grade_level': gradeLevel,
        'total_nodes': totalNodes,
        'initial_node_id': initialNodeId,
        'nodes': nodes.map((e) => e.toJson()).toList(),
      };
}

class Badge {
  final String badgeId;
  final String name;
  final String description;
  final String? iconUrl;
  final String category;
  final int requiredXp;
  final String? unlockedAt;

  Badge({
    required this.badgeId,
    required this.name,
    required this.description,
    this.iconUrl,
    this.category = 'explorer',
    this.requiredXp = 50,
    this.unlockedAt,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      badgeId: json['badge_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String?,
      category: json['category'] as String? ?? 'explorer',
      requiredXp: json['required_xp'] as int? ?? 50,
      unlockedAt: json['unlocked_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'badge_id': badgeId,
        'name': name,
        'description': description,
        'icon_url': iconUrl,
        'category': category,
        'required_xp': requiredXp,
        'unlocked_at': unlockedAt,
      };
}

class WorldTheme {
  final String worldId;
  final String category;
  final String name;
  final String description;
  final int recommendedGrade;
  final int totalQuests;
  final List<StoryQuest> quests;

  WorldTheme({
    required this.worldId,
    required this.category,
    required this.name,
    required this.description,
    this.recommendedGrade = 1,
    this.totalQuests = 0,
    this.quests = const [],
  });

  factory WorldTheme.fromJson(Map<String, dynamic> json) {
    return WorldTheme(
      worldId: json['world_id'] as String,
      category: json['category'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      recommendedGrade: json['recommended_grade'] as int? ?? 1,
      totalQuests: json['total_quests'] as int? ?? 0,
      quests: (json['quests'] as List<dynamic>?)
              ?.map((e) => StoryQuest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'world_id': worldId,
        'category': category,
        'name': name,
        'description': description,
        'recommended_grade': recommendedGrade,
        'total_quests': totalQuests,
        'quests': quests.map((e) => e.toJson()).toList(),
      };
}

class StudentProgress {
  final String studentId;
  final String? currentWorldId;
  final String? currentQuestId;
  final String? currentNodeId;
  final int totalXp;
  final int level;
  final int starsCount;
  final List<String> completedQuests;
  final List<Badge> unlockedBadges;
  final bool offlineSynced;

  StudentProgress({
    required this.studentId,
    this.currentWorldId,
    this.currentQuestId,
    this.currentNodeId,
    this.totalXp = 0,
    this.level = 1,
    this.starsCount = 0,
    this.completedQuests = const [],
    this.unlockedBadges = const [],
    this.offlineSynced = true,
  });

  factory StudentProgress.fromJson(Map<String, dynamic> json) {
    return StudentProgress(
      studentId: json['student_id'] as String,
      currentWorldId: json['current_world_id'] as String?,
      currentQuestId: json['current_quest_id'] as String?,
      currentNodeId: json['current_node_id'] as String?,
      totalXp: json['total_xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      starsCount: json['stars_count'] as int? ?? 0,
      completedQuests: (json['completed_quests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      unlockedBadges: (json['unlocked_badges'] as List<dynamic>?)
              ?.map((e) => Badge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      offlineSynced: json['offline_synced'] as bool? ?? true,
    );
  }
}

class NodeCompletionRequest {
  final String studentId;
  final String questId;
  final String nodeId;
  final String selectedChoiceId;
  final double timeSpentSeconds;

  NodeCompletionRequest({
    required this.studentId,
    required this.questId,
    required this.nodeId,
    required this.selectedChoiceId,
    this.timeSpentSeconds = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'quest_id': questId,
        'node_id': nodeId,
        'selected_choice_id': selectedChoiceId,
        'time_spent_seconds': timeSpentSeconds,
      };
}

class NodeCompletionResponse {
  final bool success;
  final String studentId;
  final String questId;
  final String nodeId;
  final String? nextNodeId;
  final int xpEarned;
  final int totalXp;
  final List<Badge> newBadgesUnlocked;
  final String feedbackMessage;
  final bool isQuestCompleted;

  NodeCompletionResponse({
    required this.success,
    required this.studentId,
    required this.questId,
    required this.nodeId,
    this.nextNodeId,
    required this.xpEarned,
    required this.totalXp,
    this.newBadgesUnlocked = const [],
    required this.feedbackMessage,
    this.isQuestCompleted = false,
  });

  factory NodeCompletionResponse.fromJson(Map<String, dynamic> json) {
    return NodeCompletionResponse(
      success: json['success'] as bool,
      studentId: json['student_id'] as String,
      questId: json['quest_id'] as String,
      nodeId: json['node_id'] as String,
      nextNodeId: json['next_node_id'] as String?,
      xpEarned: json['xp_earned'] as int,
      totalXp: json['total_xp'] as int,
      newBadgesUnlocked: (json['new_badges_unlocked'] as List<dynamic>?)
              ?.map((e) => Badge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      feedbackMessage: json['feedback_message'] as String,
      isQuestCompleted: json['is_quest_completed'] as bool? ?? false,
    );
  }
}
