from datetime import datetime, timezone
from typing import Dict, List, Optional

from backend.app.schemas.knowledge_world import (
    Badge,
    BadgeCategory,
    ChoiceOption,
    NodeCompletionRequest,
    NodeCompletionResponse,
    QuestNode,
    StoryQuest,
    StudentProgress,
    WorldTheme,
    WorldThemeCategory,
)

# Mock in-memory sample database of Knowledge Worlds for Class 1-5
SAMPLE_WORLDS: List[WorldTheme] = [
    WorldTheme(
        world_id="world-math-jungle",
        category=WorldThemeCategory.MATH_JUNGLE,
        name="Math Jungle Quest",
        description=(
            "Explore the wild jungle while learning counting, addition, shapes, "
            "and patterns with Raja Monkey!"
        ),
        recommended_grade=1,
        total_quests=2,
        quests=[
            StoryQuest(
                quest_id="quest-math-01",
                world_id="world-math-jungle",
                title="The Banana Counting Adventure",
                description="Help Raja Monkey count wild bananas to share with friends.",
                grade_level=1,
                total_nodes=2,
                initial_node_id="node-m1-01",
                nodes=[
                    QuestNode(
                        node_id="node-m1-01",
                        quest_id="quest-math-01",
                        title="Raja's Orchard",
                        story_prompt=(
                            "Raja Monkey found 3 yellow bananas on tree A and 2 yellow "
                            "bananas on tree B. How many bananas does Raja have in total?"
                        ),
                        dialogue_speaker="Suman Teacher",
                        target_grade=1,
                        choice_options=[
                            ChoiceOption(
                                choice_id="opt-m1-01a",
                                text="5 bananas",
                                is_correct=True,
                                explanation=(
                                    "Shabash! 3 + 2 = 5 bananas! You helped Raja count "
                                    "them all!"
                                ),
                                next_node_id="node-m1-02",
                                xp_reward=20,
                            ),
                            ChoiceOption(
                                choice_id="opt-m1-01b",
                                text="4 bananas",
                                is_correct=False,
                                explanation=(
                                    "Almost! Let's count together: 1, 2, 3... plus 2 "
                                    "more makes 5 bananas!"
                                ),
                                next_node_id="node-m1-02",
                                xp_reward=10,
                            ),
                        ],
                    ),
                    QuestNode(
                        node_id="node-m1-02",
                        quest_id="quest-math-01",
                        title="Sharing with Elephants",
                        story_prompt=(
                            "Golu Elephant wants 1 banana. Raja has 5 bananas. How "
                            "many bananas remain with Raja?"
                        ),
                        dialogue_speaker="Suresh Teacher",
                        target_grade=1,
                        choice_options=[
                            ChoiceOption(
                                choice_id="opt-m1-02a",
                                text="4 bananas",
                                is_correct=True,
                                explanation="Bahut badhiya! 5 minus 1 is 4 bananas left!",
                                next_node_id=None,
                                xp_reward=25,
                            ),
                            ChoiceOption(
                                choice_id="opt-m1-02b",
                                text="3 bananas",
                                is_correct=False,
                                explanation=(
                                    "Good try! 5 minus 1 leaves 4 bananas. Keep going!"
                                ),
                                next_node_id=None,
                                xp_reward=10,
                            ),
                        ],
                    ),
                ],
            ),
        ],
    ),
    WorldTheme(
        world_id="world-word-world",
        category=WorldThemeCategory.WORD_WORLD,
        name="Word World Kingdom",
        description=(
            "Journey through the magic kingdom of phonics, alphabets, and storytelling "
            "with Suman AI Teacher!"
        ),
        recommended_grade=1,
        total_quests=1,
        quests=[
            StoryQuest(
                quest_id="quest-word-01",
                world_id="world-word-world",
                title="The Magical Rhyming Tree",
                description="Find rhyming words to unlock the door to the treehouse.",
                grade_level=1,
                total_nodes=1,
                initial_node_id="node-w1-01",
                nodes=[
                    QuestNode(
                        node_id="node-w1-01",
                        quest_id="quest-word-01",
                        title="Door of Rhymes",
                        story_prompt="Which word rhymes with 'CAT'?",
                        dialogue_speaker="Suman Teacher",
                        target_grade=1,
                        choice_options=[
                            ChoiceOption(
                                choice_id="opt-w1-01a",
                                text="HAT",
                                is_correct=True,
                                explanation="Wonderful! CAT rhymes with HAT! Splendid job!",
                                next_node_id=None,
                                xp_reward=20,
                            ),
                            ChoiceOption(
                                choice_id="opt-w1-01b",
                                text="DOG",
                                is_correct=False,
                                explanation=(
                                    "Close! CAT and HAT end with the same 'AT' sound. "
                                    "Great effort!"
                                ),
                                next_node_id=None,
                                xp_reward=10,
                            ),
                        ],
                    ),
                ],
            )
        ],
    ),
    WorldTheme(
        world_id="world-science-safari",
        category=WorldThemeCategory.SCIENCE_SAFARI,
        name="Science Safari Explorer",
        description=(
            "Discover animals, plants, water cycles, and natural wonders across India!"
        ),
        recommended_grade=1,
        total_quests=1,
        quests=[
            StoryQuest(
                quest_id="quest-sci-01",
                world_id="world-science-safari",
                title="The Plant & Seed Mystery",
                description="Learn how tiny seeds grow into big green trees.",
                grade_level=1,
                total_nodes=1,
                initial_node_id="node-s1-01",
                nodes=[
                    QuestNode(
                        node_id="node-s1-01",
                        quest_id="quest-sci-01",
                        title="Sun and Water",
                        story_prompt="What does a seed need to grow into a plant?",
                        dialogue_speaker="Suresh Teacher",
                        target_grade=1,
                        choice_options=[
                            ChoiceOption(
                                choice_id="opt-s1-01a",
                                text="Sunlight and Water",
                                is_correct=True,
                                explanation=(
                                    "Spot on! Plants need sunlight and water to make "
                                    "food and grow tall!"
                                ),
                                next_node_id=None,
                                xp_reward=20,
                            ),
                            ChoiceOption(
                                choice_id="opt-s1-01b",
                                text="Chocolate and Milk",
                                is_correct=False,
                                explanation=(
                                    "Plants love sunlight and water best! Great "
                                    "imagination though!"
                                ),
                                next_node_id=None,
                                xp_reward=10,
                            ),
                        ],
                    ),
                ],
            )
        ],
    ),
]

AVAILABLE_BADGES: List[Badge] = [
    Badge(
        badge_id="badge-first-step",
        name="First Explorer",
        description="Completed your very first story quest node!",
        icon_url="assets/badges/first_step.png",
        category=BadgeCategory.EXPLORER,
        required_xp=10,
    ),
    Badge(
        badge_id="badge-math-star",
        name="Math Jungle Star",
        description="Earned 30+ XP in Math Jungle Quests!",
        icon_url="assets/badges/math_star.png",
        category=BadgeCategory.MATH_MASTER,
        required_xp=30,
    ),
    Badge(
        badge_id="badge-word-wizard",
        name="Word Wizard",
        description="Mastered phonics and rhyming words in Word World!",
        icon_url="assets/badges/word_wizard.png",
        category=BadgeCategory.STORY_TELLER,
        required_xp=50,
    ),
]

# In-memory progress tracker per student for offline/development mock state
STUDENT_PROGRESS_STORE: Dict[str, StudentProgress] = {}


class KnowledgeWorldService:
    """Service handling story quest progression, gamification rewards, and offline sync."""

    def get_all_worlds(self) -> List[WorldTheme]:
        """Fetch all available learning worlds."""
        return SAMPLE_WORLDS

    def get_world_by_id(self, world_id: str) -> Optional[WorldTheme]:
        """Fetch world by world_id."""
        for world in SAMPLE_WORLDS:
            if world.world_id == world_id:
                return world
        return None

    def get_quest_by_id(self, quest_id: str) -> Optional[StoryQuest]:
        """Fetch story quest by quest_id."""
        for world in SAMPLE_WORLDS:
            for quest in world.quests:
                if quest.quest_id == quest_id:
                    return quest
        return None

    def get_node_by_id(self, quest_id: str, node_id: str) -> Optional[QuestNode]:
        """Fetch specific quest node by quest_id and node_id."""
        quest = self.get_quest_by_id(quest_id)
        if not quest:
            return None
        for node in quest.nodes:
            if node.node_id == node_id:
                return node
        return None

    def get_or_create_student_progress(self, student_id: str) -> StudentProgress:
        """Fetch student progress or initialize default if not existing."""
        if student_id not in STUDENT_PROGRESS_STORE:
            STUDENT_PROGRESS_STORE[student_id] = StudentProgress(
                student_id=student_id,
                total_xp=0,
                level=1,
                stars_count=0,
                completed_quests=[],
                unlocked_badges=[],
                offline_synced=True,
            )
        return STUDENT_PROGRESS_STORE[student_id]

    def complete_quest_node(
        self, request: NodeCompletionRequest
    ) -> NodeCompletionResponse:
        """Resolve interactive choice, award non-monetary XP/badges, advance quest tree."""
        quest = self.get_quest_by_id(request.quest_id)
        if not quest:
            return NodeCompletionResponse(
                success=False,
                student_id=request.student_id,
                quest_id=request.quest_id,
                node_id=request.node_id,
                next_node_id=None,
                xp_earned=0,
                total_xp=0,
                new_badges_unlocked=[],
                feedback_message="Quest not found.",
                is_quest_completed=False,
            )

        node = self.get_node_by_id(request.quest_id, request.node_id)
        if not node:
            return NodeCompletionResponse(
                success=False,
                student_id=request.student_id,
                quest_id=request.quest_id,
                node_id=request.node_id,
                next_node_id=None,
                xp_earned=0,
                total_xp=0,
                new_badges_unlocked=[],
                feedback_message="Quest node not found.",
                is_quest_completed=False,
            )

        selected_option = next(
            (
                opt
                for opt in node.choice_options
                if opt.choice_id == request.selected_choice_id
            ),
            None,
        )

        if not selected_option:
            return NodeCompletionResponse(
                success=False,
                student_id=request.student_id,
                quest_id=request.quest_id,
                node_id=request.node_id,
                next_node_id=None,
                xp_earned=0,
                total_xp=0,
                new_badges_unlocked=[],
                feedback_message="Invalid choice selected.",
                is_quest_completed=False,
            )

        # Update student progression
        progress = self.get_or_create_student_progress(request.student_id)
        xp_earned = selected_option.xp_reward
        progress.total_xp += xp_earned
        if selected_option.is_correct:
            progress.stars_count += 1

        # Calculate student level (1 level per 50 XP)
        progress.level = max(1, (progress.total_xp // 50) + 1)

        # Evaluate badge unlocks
        new_badges: List[Badge] = []
        unlocked_badge_ids = {b.badge_id for b in progress.unlocked_badges}

        for badge_def in AVAILABLE_BADGES:
            if badge_def.badge_id not in unlocked_badge_ids:
                if progress.total_xp >= badge_def.required_xp:
                    earned_badge = badge_def.model_copy()
                    earned_badge.unlocked_at = datetime.now(timezone.utc).isoformat()
                    progress.unlocked_badges.append(earned_badge)
                    new_badges.append(earned_badge)

        next_node_id = selected_option.next_node_id
        is_completed = next_node_id is None

        if is_completed and request.quest_id not in progress.completed_quests:
            progress.completed_quests.append(request.quest_id)

        feedback_text = (
            selected_option.explanation
            or "Great effort! Suman Teacher is proud of your progress!"
        )

        return NodeCompletionResponse(
            success=True,
            student_id=request.student_id,
            quest_id=request.quest_id,
            node_id=request.node_id,
            next_node_id=next_node_id,
            xp_earned=xp_earned,
            total_xp=progress.total_xp,
            new_badges_unlocked=new_badges,
            feedback_message=feedback_text,
            is_quest_completed=is_completed,
        )


knowledge_world_service = KnowledgeWorldService()
