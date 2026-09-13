from enum import Enum
from typing import List, Optional

from pydantic import BaseModel, Field


class SubjectCode(str, Enum):
    ENGLISH = "english"
    HINDI = "hindi"
    MARATHI = "marathi"
    MATHEMATICS = "mathematics"
    EVS_GK = "evs_gk"


class ExerciseType(str, Enum):
    MULTIPLE_CHOICE = "multiple_choice"
    VISUAL_MATCH = "visual_match"
    FILL_IN_BLANK = "fill_in_blank"
    TRUE_FALSE = "true_false"


class LearningOutcome(BaseModel):
    id: str = Field(..., description="Unique ID for learning outcome")
    outcome_code: str = Field(..., description="Standard curriculum code")
    description: str = Field(..., description="Description of expected learning outcome")
    blooms_level: str = Field(..., description="Bloom's Taxonomy level")
    understanding_first_principle: str = Field(
        ..., description="Core pedagogical principle driving this outcome"
    )
    cbse_academic_year: str = Field(
        default="2026-27", description="CBSE Academic Year Versioning"
    )


class Concept(BaseModel):
    id: str = Field(..., description="Concept ID")
    title: str = Field(..., description="Concept title")
    explanation: str = Field(..., description="Kid-friendly conceptual explanation")
    visual_cues: List[str] = Field(
        default_factory=list, description="Visual hints descriptions"
    )
    learning_outcomes: List[LearningOutcome] = Field(default_factory=list)
    cbse_academic_year: str = Field(
        default="2026-27", description="CBSE Academic Year Versioning"
    )


class ExerciseItem(BaseModel):
    id: str = Field(..., description="Exercise ID")
    type: ExerciseType = Field(..., description="Type of practice exercise item")
    question: str = Field(..., description="Exercise prompt or question text")
    options: List[str] = Field(
        default_factory=list, description="Choices for multiple choice"
    )
    correct_answer: str = Field(..., description="Correct answer string")
    hint: Optional[str] = Field(None, description="Gentle hint for student guidance")
    explanation: Optional[str] = Field(None, description="Concept feedback after attempt")
    cbse_academic_year: str = Field(
        default="2026-27", description="CBSE Academic Year Versioning"
    )


class AssessmentItem(BaseModel):
    id: str = Field(..., description="Assessment ID")
    exercise: ExerciseItem
    weightage: float = Field(default=1.0, description="Score weightage")
    cbse_academic_year: str = Field(
        default="2026-27", description="CBSE Academic Year Versioning"
    )


class Subtopic(BaseModel):
    id: str = Field(..., description="Subtopic ID")
    title: str = Field(..., description="Subtopic title")
    sequence_order: int = Field(..., description="Ordering sequence")
    concepts: List[Concept] = Field(default_factory=list)
    exercises: List[ExerciseItem] = Field(default_factory=list)
    cbse_academic_year: str = Field(
        default="2026-27", description="CBSE Academic Year Versioning"
    )


class Topic(BaseModel):
    id: str = Field(..., description="Topic ID")
    title: str = Field(..., description="Topic title")
    sequence_order: int = Field(..., description="Ordering sequence")
    subtopics: List[Subtopic] = Field(default_factory=list)
    cbse_academic_year: str = Field(
        default="2026-27", description="CBSE Academic Year Versioning"
    )


class Subject(BaseModel):
    id: str = Field(..., description="Subject ID")
    code: SubjectCode = Field(..., description="Subject unique code")
    title_en: str = Field(..., description="English title")
    title_native: str = Field(..., description="Native language title")
    description: str = Field(..., description="Subject overview")
    language: str = Field(..., description="Primary language identifier")
    grade_level: int = Field(default=1, description="Grade level (1 for Class 1)")
    topics: List[Topic] = Field(default_factory=list)
    cbse_academic_year: str = Field(
        default="2026-27", description="CBSE Academic Year Versioning"
    )


class CurriculumVersion(BaseModel):
    version: str = Field(..., description="Semantic version of curriculum")
    release_date: str = Field(..., description="ISO release date")
    grade_level: int = Field(default=1, description="Target class/grade level")
    cbse_compliant: bool = Field(default=True, description="CBSE alignment flag")
    cbse_academic_year: str = Field(
        default="2026-27", description="CBSE Academic Year Versioning"
    )
    supported_subjects: List[SubjectCode] = Field(default_factory=list)


class LessonBlueprint(BaseModel):
    id: str = Field(..., description="Lesson Blueprint ID")
    subject_code: SubjectCode
    grade_level: int = Field(default=1)
    title: str = Field(..., description="Lesson Title")
    topic_id: str
    subtopic_id: str
    concepts: List[Concept] = Field(default_factory=list)
    assessment_items: List[AssessmentItem] = Field(default_factory=list)
    curriculum_version: str = Field(default="1.0.0")
    cbse_academic_year: str = Field(
        default="2026-27", description="CBSE Academic Year Versioning"
    )


# ==========================================
# Suresh AI Study Guide Data Schemas
# ==========================================
class StudyProgressTrack(BaseModel):
    student_id: str = Field(..., description="Student ID")
    completed_concept_ids: List[str] = Field(default_factory=list)
    completed_exercise_ids: List[str] = Field(default_factory=list)
    mastery_percentage: float = Field(default=0.0)
    last_active_date: str = Field(default="2026-09-11")


class DailyPracticeReminder(BaseModel):
    reminder_id: str = Field(..., description="Reminder ID")
    student_id: str = Field(..., description="Student ID")
    message: str = Field(..., description="Encouragement message from Suresh Teacher")
    recommended_subject: SubjectCode = Field(..., description="Recommended subject")
    recommended_topic_id: str = Field(..., description="Target topic ID")
    target_minutes: int = Field(default=15, description="Target practice duration")


class RevisionPrompt(BaseModel):
    prompt_id: str = Field(..., description="Revision prompt ID")
    student_id: str = Field(..., description="Student ID")
    concept_id: str = Field(..., description="Concept ID needing revision")
    prompt_question: str = Field(..., description="Quick recall question for student")
    revision_reason: str = Field(
        default="spaced_repetition", description="Spaced repetition reason"
    )


class SureshStudyGuideSummary(BaseModel):
    student_id: str = Field(..., description="Student ID")
    mentor_name: str = Field(default="Suresh Teacher", description="Mentor persona name")
    progress: StudyProgressTrack = Field(..., description="Progress details")
    daily_reminders: List[DailyPracticeReminder] = Field(default_factory=list)
    revision_prompts: List[RevisionPrompt] = Field(default_factory=list)


class ProgressUpdateRequest(BaseModel):
    student_id: str = Field(..., description="Student ID")
    concept_id: Optional[str] = Field(None, description="Concept ID completed")
    exercise_id: Optional[str] = Field(None, description="Exercise ID attempted")
    is_correct: bool = Field(default=True, description="True if attempt was correct")
