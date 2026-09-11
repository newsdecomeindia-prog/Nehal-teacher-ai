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


class Concept(BaseModel):
    id: str = Field(..., description="Concept ID")
    title: str = Field(..., description="Concept title")
    explanation: str = Field(..., description="Kid-friendly conceptual explanation")
    visual_cues: List[str] = Field(
        default_factory=list, description="Visual hints descriptions"
    )
    learning_outcomes: List[LearningOutcome] = Field(default_factory=list)


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


class AssessmentItem(BaseModel):
    id: str = Field(..., description="Assessment ID")
    exercise: ExerciseItem
    weightage: float = Field(default=1.0, description="Score weightage")


class Subtopic(BaseModel):
    id: str = Field(..., description="Subtopic ID")
    title: str = Field(..., description="Subtopic title")
    sequence_order: int = Field(..., description="Ordering sequence")
    concepts: List[Concept] = Field(default_factory=list)
    exercises: List[ExerciseItem] = Field(default_factory=list)


class Topic(BaseModel):
    id: str = Field(..., description="Topic ID")
    title: str = Field(..., description="Topic title")
    sequence_order: int = Field(..., description="Ordering sequence")
    subtopics: List[Subtopic] = Field(default_factory=list)


class Subject(BaseModel):
    id: str = Field(..., description="Subject ID")
    code: SubjectCode = Field(..., description="Subject unique code")
    title_en: str = Field(..., description="English title")
    title_native: str = Field(..., description="Native language title")
    description: str = Field(..., description="Subject overview")
    language: str = Field(..., description="Primary language identifier")
    grade_level: int = Field(default=1, description="Grade level (1 for Class 1)")
    topics: List[Topic] = Field(default_factory=list)


class CurriculumVersion(BaseModel):
    version: str = Field(..., description="Semantic version of curriculum")
    release_date: str = Field(..., description="ISO release date")
    grade_level: int = Field(default=1, description="Target class/grade level")
    cbse_compliant: bool = Field(default=True, description="CBSE alignment flag")
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
