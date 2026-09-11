from enum import Enum
from typing import List, Optional

from pydantic import BaseModel, Field


class ExamType(str, Enum):
    DIAGNOSTIC = "diagnostic"
    FORMATIVE = "formative"
    SUMMATIVE = "summative"


class QuestionType(str, Enum):
    MULTIPLE_CHOICE = "multiple_choice"
    FILL_IN_BLANK = "fill_in_blank"
    SHORT_ANSWER = "short_answer"


class SubjectCategory(str, Enum):
    MATH = "math"
    HINDI = "hindi"
    ENGLISH = "english"
    EVS = "evs"
    GENERAL = "general"


class GapSeverity(str, Enum):
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"


class ConsentStatus(str, Enum):
    GRANTED = "granted"
    REVOKED = "revoked"
    PENDING = "pending"


class ExamQuestionOption(BaseModel):
    option_id: str = Field(..., description="Unique option identifier")
    text: str = Field(..., description="Option text")
    is_correct: bool = Field(default=False, description="Whether option is correct")


class ExamQuestion(BaseModel):
    question_id: str = Field(..., description="Unique question ID")
    question_text: str = Field(..., description="Question statement")
    question_type: QuestionType = Field(
        default=QuestionType.MULTIPLE_CHOICE, description="Type of question"
    )
    subject: SubjectCategory = Field(..., description="Subject domain")
    topic: str = Field(..., description="Topic area (e.g., Addition, Phonology)")
    target_grade: int = Field(default=1, ge=1, le=5, description="Grade level (1-5)")
    options: Optional[List[ExamQuestionOption]] = Field(
        None, description="Options for multiple choice questions"
    )
    correct_answer: str = Field(..., description="Correct text or option_id")
    explanation: Optional[str] = Field(None, description="Explanatory text for answer")
    points: int = Field(default=10, ge=1, description="Marks awarded for correct answer")


class ExamPaper(BaseModel):
    exam_id: str = Field(..., description="Unique exam paper ID")
    title: str = Field(..., description="Exam title")
    exam_type: ExamType = Field(default=ExamType.DIAGNOSTIC, description="Type of exam")
    target_grade: int = Field(default=1, ge=1, le=5, description="Grade level (1-5)")
    subject: SubjectCategory = Field(..., description="Subject domain")
    duration_minutes: int = Field(default=15, ge=5, description="Suggested time limit")
    total_questions: int = Field(default=5, ge=1, description="Number of questions")
    total_marks: int = Field(default=50, ge=1, description="Maximum total marks")
    questions: List[ExamQuestion] = Field(default_factory=list, description="Questions")


class ExamGenerateRequest(BaseModel):
    student_id: str = Field(..., description="Unique student ID")
    grade_level: int = Field(default=1, ge=1, le=5, description="Grade level (1-5)")
    subject: SubjectCategory = Field(default=SubjectCategory.MATH, description="Subject domain")
    exam_type: ExamType = Field(default=ExamType.DIAGNOSTIC, description="Type of exam")
    num_questions: int = Field(default=5, ge=1, le=20, description="Requested question count")


class StudentAnswer(BaseModel):
    question_id: str = Field(..., description="Question ID being answered")
    answer_text: str = Field(..., description="Student's answered text or option_id")
    selected_option_id: Optional[str] = Field(None, description="Option ID selected if MCQ")
    time_spent_seconds: float = Field(default=0.0, ge=0.0, description="Time spent")


class ExamSubmissionRequest(BaseModel):
    student_id: str = Field(..., description="Unique student ID")
    exam_id: str = Field(..., description="Exam paper ID")
    grade_level: int = Field(default=1, ge=1, le=5, description="Grade level")
    subject: SubjectCategory = Field(default=SubjectCategory.MATH, description="Subject domain")
    answers: List[StudentAnswer] = Field(..., description="Student responses")


class QuestionEvaluation(BaseModel):
    question_id: str = Field(..., description="Question ID")
    is_correct: bool = Field(..., description="Whether answer was correct")
    points_awarded: int = Field(..., ge=0, description="Points awarded")
    max_points: int = Field(..., ge=1, description="Maximum points for question")
    student_answer: str = Field(..., description="Answer given by student")
    correct_answer: str = Field(..., description="Expected correct answer")
    explanation: Optional[str] = Field(None, description="Explanation for correct answer")


class ExamSubmissionResponse(BaseModel):
    submission_id: str = Field(..., description="Unique submission evaluation ID")
    student_id: str = Field(..., description="Student ID")
    exam_id: str = Field(..., description="Exam paper ID")
    subject: SubjectCategory = Field(..., description="Subject domain")
    total_score: int = Field(..., ge=0, description="Total score obtained")
    max_score: int = Field(..., ge=1, description="Maximum achievable score")
    percentage: float = Field(..., ge=0.0, le=100.0, description="Percentage score")
    strength_areas: List[str] = Field(default_factory=list, description="Strength topics")
    weakness_areas: List[str] = Field(default_factory=list, description="Weakness topics")
    question_evaluations: List[QuestionEvaluation] = Field(
        default_factory=list, description="Detailed itemized evaluation"
    )
    feedback_message: str = Field(..., description="Encouraging summary feedback")


class SubjectMastery(BaseModel):
    subject: SubjectCategory = Field(..., description="Subject domain")
    score_percentage: float = Field(..., ge=0.0, le=100.0, description="Average percentage")
    mastery_level: str = Field(..., description="Level label")
    topics_mastered: List[str] = Field(default_factory=list, description="Mastered topics")
    topics_needing_improvement: List[str] = Field(
        default_factory=list, description="Topics needing improvement"
    )


class LearningGapIndicator(BaseModel):
    subject: SubjectCategory = Field(..., description="Subject domain")
    topic: str = Field(..., description="Topic area")
    severity: GapSeverity = Field(default=GapSeverity.MEDIUM, description="Gap severity")
    gap_description: str = Field(..., description="Diagnostic explanation of gap")
    recommended_action: str = Field(..., description="Actionable recommendation")


class DPDPParentConsent(BaseModel):
    parent_id: str = Field(..., description="Parent/Guardian ID")
    child_student_id: str = Field(..., description="Child student ID")
    dpdp_consent_granted: bool = Field(default=True, description="DPDP Act India consent")
    coppa_consent_granted: bool = Field(default=True, description="COPPA parental consent")
    allow_voice_data_processing: bool = Field(
        default=False, description="Consent for ephemeral voice evaluation"
    )
    allow_analytics_aggregation: bool = Field(
        default=True, description="Consent for anonymized diagnostic metrics"
    )
    data_retention_days: int = Field(default=30, ge=1, le=365, description="Retention policy days")
    consent_status: ConsentStatus = Field(default=ConsentStatus.GRANTED, description="Status")


class ParentDashboardResponse(BaseModel):
    parent_id: str = Field(..., description="Parent ID")
    child_student_id: str = Field(..., description="Child student ID")
    child_name: str = Field(..., description="Child preferred display name")
    grade_level: int = Field(default=1, ge=1, le=5, description="Grade level")
    overall_mastery_percentage: float = Field(
        ..., ge=0.0, le=100.0, description="Aggregated mastery percentage"
    )
    total_learning_hours: float = Field(default=0.0, ge=0.0, description="Learning hours")
    total_exams_taken: int = Field(default=0, ge=0, description="Completed exam count")
    subject_mastery: List[SubjectMastery] = Field(
        default_factory=list, description="Subject mastery breakdown"
    )
    learning_gaps: List[LearningGapIndicator] = Field(
        default_factory=list, description="Active gap indicators"
    )
    strengths: List[str] = Field(default_factory=list, description="Highlighted strengths")
    consent_settings: DPDPParentConsent = Field(..., description="Privacy consent settings")
