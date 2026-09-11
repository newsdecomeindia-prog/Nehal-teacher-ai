from enum import Enum
from typing import List, Optional

from pydantic import BaseModel, Field


class WorldThemeCategory(str, Enum):
    MATH_JUNGLE = "math_jungle"
    WORD_WORLD = "word_world"
    SCIENCE_SAFARI = "science_safari"


class QuestType(str, Enum):
    STORY_CHOICE = "story_choice"
    PUZZLE_CHALLENGE = "puzzle_challenge"
    VOICE_QUEST = "voice_quest"


class BadgeCategory(str, Enum):
    EXPLORER = "explorer"
    MATH_MASTER = "math_master"
    STORY_TELLER = "story_teller"
    SCIENCE_STAR = "science_star"


class ChoiceOption(BaseModel):
    choice_id: str = Field(..., description="Unique ID for choice option")
    text: str = Field(..., description="Child-friendly text choice")
    is_correct: bool = Field(
        default=True, description="Whether choice leads to successful understanding"
    )
    explanation: Optional[str] = Field(
        None, description="Encouraging feedback/explanation for choice"
    )
    next_node_id: Optional[str] = Field(
        None, description="Next quest node ID to transition to"
    )
    xp_reward: int = Field(
        default=10, ge=0, description="Non-monetary XP rewarded for choice"
    )


class QuestNode(BaseModel):
    node_id: str = Field(..., description="Unique node ID in the quest tree")
    quest_id: str = Field(..., description="Parent quest ID")
    title: str = Field(..., description="Title of the story node")
    story_prompt: str = Field(..., description="Interactive narrative text or question")
    dialogue_speaker: Optional[str] = Field(
        None, description="Name of character speaking (Suman, Suresh, Raja Monkey)"
    )
    choice_options: List[ChoiceOption] = Field(
        default_factory=list, description="Interactive choices available"
    )
    media_asset_url: Optional[str] = Field(
        None, description="Visual illustration or audio prompt asset"
    )
    target_grade: int = Field(
        default=1, ge=1, le=5, description="Target Class level (1 to 5)"
    )


class StoryQuest(BaseModel):
    quest_id: str = Field(..., description="Unique quest ID")
    world_id: str = Field(..., description="Parent world ID")
    title: str = Field(..., description="Title of the quest")
    description: str = Field(..., description="Brief quest summary")
    grade_level: int = Field(
        default=1, ge=1, le=5, description="Target Class level (1 to 5)"
    )
    total_nodes: int = Field(default=1, ge=1, description="Number of story nodes in quest")
    initial_node_id: str = Field(..., description="Entry node ID for the quest")
    nodes: List[QuestNode] = Field(
        default_factory=list, description="All nodes in quest tree"
    )


class Badge(BaseModel):
    badge_id: str = Field(..., description="Unique badge ID")
    name: str = Field(..., description="Child-friendly badge name")
    description: str = Field(..., description="How badge is earned")
    icon_url: Optional[str] = Field(None, description="Icon asset path or URL")
    category: BadgeCategory = Field(
        default=BadgeCategory.EXPLORER, description="Badge category"
    )
    required_xp: int = Field(
        default=50, ge=0, description="XP threshold to unlock badge"
    )
    unlocked_at: Optional[str] = Field(
        None, description="Timestamp when student earned badge"
    )


class WorldTheme(BaseModel):
    world_id: str = Field(..., description="Unique world ID")
    category: WorldThemeCategory = Field(..., description="Theme category")
    name: str = Field(..., description="World name (e.g. Math Jungle)")
    description: str = Field(..., description="Description of the world")
    recommended_grade: int = Field(
        default=1, ge=1, le=5, description="Target grade level"
    )
    total_quests: int = Field(
        default=1, ge=0, description="Count of quests in this world"
    )
    quests: List[StoryQuest] = Field(
        default_factory=list, description="Available quests in world"
    )


class StudentProgress(BaseModel):
    student_id: str = Field(..., description="Unique student ID")
    current_world_id: Optional[str] = Field(None, description="Currently active world")
    current_quest_id: Optional[str] = Field(None, description="Currently active quest")
    current_node_id: Optional[str] = Field(None, description="Currently active quest node")
    total_xp: int = Field(
        default=0, ge=0, description="Accumulated non-monetary experience points"
    )
    level: int = Field(default=1, ge=1, description="Calculated student level from XP")
    stars_count: int = Field(default=0, ge=0, description="Stars collected during quests")
    completed_quests: List[str] = Field(
        default_factory=list, description="List of completed quest IDs"
    )
    unlocked_badges: List[Badge] = Field(
        default_factory=list, description="Badges earned by student"
    )
    offline_synced: bool = Field(default=True, description="State of offline-first sync")


class NodeCompletionRequest(BaseModel):
    student_id: str = Field(..., description="Unique student ID")
    quest_id: str = Field(..., description="Quest ID being played")
    node_id: str = Field(..., description="Node ID being answered")
    selected_choice_id: str = Field(..., description="Choice selected by student")
    time_spent_seconds: float = Field(
        default=0.0, ge=0.0, description="Time spent on node in seconds"
    )


class NodeCompletionResponse(BaseModel):
    success: bool = Field(..., description="Whether node completion succeeded")
    student_id: str = Field(..., description="Student ID")
    quest_id: str = Field(..., description="Quest ID")
    node_id: str = Field(..., description="Completed node ID")
    next_node_id: Optional[str] = Field(
        None, description="Next node ID in tree (None if quest finished)"
    )
    xp_earned: int = Field(..., ge=0, description="XP earned for this node completion")
    total_xp: int = Field(..., ge=0, description="Updated total XP for student")
    new_badges_unlocked: List[Badge] = Field(
        default_factory=list, description="Badges unlocked by this node completion"
    )
    feedback_message: str = Field(
        ..., description="Encouraging child-friendly feedback message"
    )
    is_quest_completed: bool = Field(
        default=False, description="True if quest is complete"
    )
