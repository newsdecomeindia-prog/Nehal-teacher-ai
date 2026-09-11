import uuid
from typing import Dict, List, Optional

from backend.app.schemas.analytics import (
    ConsentStatus,
    DPDPParentConsent,
    ExamGenerateRequest,
    ExamPaper,
    ExamQuestion,
    ExamQuestionOption,
    ExamSubmissionRequest,
    ExamSubmissionResponse,
    ExamType,
    GapSeverity,
    LearningGapIndicator,
    ParentDashboardResponse,
    QuestionEvaluation,
    QuestionType,
    SubjectCategory,
    SubjectMastery,
)


class AnalyticsService:
    """Service handling exam papers, evaluation, gap analysis, and parent reports."""

    def __init__(self):
        # Sample question bank for Classes 1-5 across Math, Hindi, English, EVS
        self._question_bank: List[ExamQuestion] = [
            # Class 1 Math
            ExamQuestion(
                question_id="q-m1-01",
                question_text="What is 3 + 4?",
                question_type=QuestionType.MULTIPLE_CHOICE,
                subject=SubjectCategory.MATH,
                topic="Addition",
                target_grade=1,
                options=[
                    ExamQuestionOption(option_id="opt-m1-01a", text="5", is_correct=False),
                    ExamQuestionOption(option_id="opt-m1-01b", text="7", is_correct=True),
                    ExamQuestionOption(option_id="opt-m1-01c", text="8", is_correct=False),
                ],
                correct_answer="opt-m1-01b",
                explanation="3 plus 4 equals 7.",
                points=10,
            ),
            ExamQuestion(
                question_id="q-m1-02",
                question_text="Which shape has 3 sides?",
                question_type=QuestionType.MULTIPLE_CHOICE,
                subject=SubjectCategory.MATH,
                topic="Shapes & Geometry",
                target_grade=1,
                options=[
                    ExamQuestionOption(option_id="opt-m1-02a", text="Square", is_correct=False),
                    ExamQuestionOption(option_id="opt-m1-02b", text="Triangle", is_correct=True),
                    ExamQuestionOption(option_id="opt-m1-02c", text="Circle", is_correct=False),
                ],
                correct_answer="opt-m1-02b",
                explanation="A triangle has 3 straight sides.",
                points=10,
            ),
            ExamQuestion(
                question_id="q-m1-03",
                question_text="Fill in the missing number: 2, 4, 6, __, 10",
                question_type=QuestionType.FILL_IN_BLANK,
                subject=SubjectCategory.MATH,
                topic="Pattern Recognition",
                target_grade=1,
                correct_answer="8",
                explanation="The sequence increases by 2 each time.",
                points=10,
            ),
            # Class 1 Hindi
            ExamQuestion(
                question_id="q-h1-01",
                question_text="'अ' से क्या होता है?",
                question_type=QuestionType.MULTIPLE_CHOICE,
                subject=SubjectCategory.HINDI,
                topic="Vowels & Phonology",
                target_grade=1,
                options=[
                    ExamQuestionOption(option_id="opt-h1-01a", text="अनार", is_correct=True),
                    ExamQuestionOption(option_id="opt-h1-01b", text="आम", is_correct=False),
                    ExamQuestionOption(option_id="opt-h1-01c", text="इमली", is_correct=False),
                ],
                correct_answer="opt-h1-01a",
                explanation="'अ' से अनार बनता है।",
                points=10,
            ),
            ExamQuestion(
                question_id="q-h1-02",
                question_text="चित्र देखकर बताइए: 'क' से क्या शुरू होता है?",
                question_type=QuestionType.MULTIPLE_CHOICE,
                subject=SubjectCategory.HINDI,
                topic="Consonants",
                target_grade=1,
                options=[
                    ExamQuestionOption(option_id="opt-h1-02a", text="कमल", is_correct=True),
                    ExamQuestionOption(option_id="opt-h1-02b", text="खरगोश", is_correct=False),
                    ExamQuestionOption(option_id="opt-h1-02c", text="गमला", is_correct=False),
                ],
                correct_answer="opt-h1-02a",
                explanation="'क' से कमल होता है।",
                points=10,
            ),
            # Class 1 English
            ExamQuestion(
                question_id="q-e1-01",
                question_text="Select the word that starts with letter 'B':",
                question_type=QuestionType.MULTIPLE_CHOICE,
                subject=SubjectCategory.ENGLISH,
                topic="Alphabet Recognition",
                target_grade=1,
                options=[
                    ExamQuestionOption(option_id="opt-e1-01a", text="Apple", is_correct=False),
                    ExamQuestionOption(option_id="opt-e1-01b", text="Ball", is_correct=True),
                    ExamQuestionOption(option_id="opt-e1-01c", text="Cat", is_correct=False),
                ],
                correct_answer="opt-e1-01b",
                explanation="Ball starts with the letter B.",
                points=10,
            ),
            ExamQuestion(
                question_id="q-e1-02",
                question_text="What is the plural of 'Cat'?",
                question_type=QuestionType.FILL_IN_BLANK,
                subject=SubjectCategory.ENGLISH,
                topic="Plurals",
                target_grade=1,
                correct_answer="cats",
                explanation="Adding 's' to cat makes it cats.",
                points=10,
            ),
            # Class 1 EVS
            ExamQuestion(
                question_id="q-ev1-01",
                question_text="Which part of the body helps us to see?",
                question_type=QuestionType.MULTIPLE_CHOICE,
                subject=SubjectCategory.EVS,
                topic="Human Body",
                target_grade=1,
                options=[
                    ExamQuestionOption(option_id="opt-ev1-01a", text="Ears", is_correct=False),
                    ExamQuestionOption(option_id="opt-ev1-01b", text="Eyes", is_correct=True),
                    ExamQuestionOption(option_id="opt-ev1-01c", text="Nose", is_correct=False),
                ],
                correct_answer="opt-ev1-01b",
                explanation="Our eyes help us see things around us.",
                points=10,
            ),
            # Class 2-5 Sample questions
            ExamQuestion(
                question_id="q-m2-01",
                question_text="What is 15 - 7?",
                question_type=QuestionType.MULTIPLE_CHOICE,
                subject=SubjectCategory.MATH,
                topic="Subtraction",
                target_grade=2,
                options=[
                    ExamQuestionOption(option_id="opt-m2-01a", text="8", is_correct=True),
                    ExamQuestionOption(option_id="opt-m2-01b", text="7", is_correct=False),
                    ExamQuestionOption(option_id="opt-m2-01c", text="9", is_correct=False),
                ],
                correct_answer="opt-m2-01a",
                explanation="15 minus 7 equals 8.",
                points=10,
            ),
        ]

        # In-memory storage for parental consent settings and student histories
        self._consent_db: Dict[str, DPDPParentConsent] = {}

    def generate_exam_paper(self, req: ExamGenerateRequest) -> ExamPaper:
        """Generates a diagnostic/formative exam paper for given grade and subject."""
        # Filter matching grade and subject questions
        matching = [
            q
            for q in self._question_bank
            if q.target_grade == req.grade_level and q.subject == req.subject
        ]

        # Fallback to grade level if subject mismatch
        if not matching:
            matching = [q for q in self._question_bank if q.target_grade == req.grade_level]
        if not matching:
            matching = self._question_bank

        selected_questions = matching[: req.num_questions]
        total_marks = sum(q.points for q in selected_questions)
        exam_id = f"exam-{req.subject.value}-g{req.grade_level}-{uuid.uuid4().hex[:6]}"

        is_diag = req.exam_type == ExamType.DIAGNOSTIC
        title_prefix = "Diagnostic Assessment" if is_diag else "Formative Quiz"
        title = f"{title_prefix} - Class {req.grade_level} ({req.subject.value.upper()})"

        return ExamPaper(
            exam_id=exam_id,
            title=title,
            exam_type=req.exam_type,
            target_grade=req.grade_level,
            subject=req.subject,
            duration_minutes=max(10, len(selected_questions) * 3),
            total_questions=len(selected_questions),
            total_marks=total_marks,
            questions=selected_questions,
        )

    def submit_exam_paper(self, req: ExamSubmissionRequest) -> ExamSubmissionResponse:
        """Evaluates student exam answers, calculates scores, and identifies strength/gap areas."""
        evaluations: List[QuestionEvaluation] = []
        total_score = 0
        max_score = 0
        strengths: List[str] = []
        weaknesses: List[str] = []

        q_dict = {q.question_id: q for q in self._question_bank}

        for ans in req.answers:
            q = q_dict.get(ans.question_id)
            if not q:
                max_score += 10
                continue

            max_score += q.points
            is_correct = False

            if q.question_type == QuestionType.MULTIPLE_CHOICE:
                selected = ans.selected_option_id or ans.answer_text
                is_correct = selected == q.correct_answer
            else:
                is_correct = ans.answer_text.strip().lower() == q.correct_answer.strip().lower()

            points_awarded = q.points if is_correct else 0
            total_score += points_awarded

            if is_correct:
                if q.topic not in strengths:
                    strengths.append(q.topic)
            else:
                if q.topic not in weaknesses:
                    weaknesses.append(q.topic)

            evaluations.append(
                QuestionEvaluation(
                    question_id=q.question_id,
                    is_correct=is_correct,
                    points_awarded=points_awarded,
                    max_points=q.points,
                    student_answer=ans.answer_text or ans.selected_option_id or "",
                    correct_answer=q.correct_answer,
                    explanation=q.explanation,
                )
            )

        max_score = max(max_score, 1)
        percentage = round((total_score / max_score) * 100.0, 1)

        if percentage >= 80:
            feedback = "Shabash! Outstanding mastery! Keep up the brilliant effort!"
        elif percentage >= 50:
            feedback = "Great effort! You're making good progress. A little more practice helps!"
        else:
            feedback = "Good try! Suman Ma'am is here to help you master these concepts."

        submission_id = f"sub-{uuid.uuid4().hex[:8]}"

        return ExamSubmissionResponse(
            submission_id=submission_id,
            student_id=req.student_id,
            exam_id=req.exam_id,
            subject=req.subject,
            total_score=total_score,
            max_score=max_score,
            percentage=percentage,
            strength_areas=strengths,
            weakness_areas=weaknesses,
            question_evaluations=evaluations,
            feedback_message=feedback,
        )

    def get_parent_dashboard(
        self, student_id: str, parent_id: Optional[str] = "parent-01"
    ) -> ParentDashboardResponse:
        """Aggregates analytics, gaps, and DPDP consent settings for parent portal."""
        consent = self._consent_db.get(student_id)
        if not consent:
            consent = DPDPParentConsent(
                parent_id=parent_id or "parent-default",
                child_student_id=student_id,
                dpdp_consent_granted=True,
                coppa_consent_granted=True,
                allow_voice_data_processing=False,
                allow_analytics_aggregation=True,
                data_retention_days=30,
                consent_status=ConsentStatus.GRANTED,
            )
            self._consent_db[student_id] = consent

        subject_masteries = [
            SubjectMastery(
                subject=SubjectCategory.MATH,
                score_percentage=85.0,
                mastery_level="Proficient",
                topics_mastered=["Addition", "Shapes & Geometry"],
                topics_needing_improvement=["Pattern Recognition"],
            ),
            SubjectMastery(
                subject=SubjectCategory.HINDI,
                score_percentage=90.0,
                mastery_level="Master",
                topics_mastered=["Vowels & Phonology", "Consonants"],
                topics_needing_improvement=[],
            ),
            SubjectMastery(
                subject=SubjectCategory.ENGLISH,
                score_percentage=75.0,
                mastery_level="Developing",
                topics_mastered=["Alphabet Recognition"],
                topics_needing_improvement=["Plurals", "Pronunciation"],
            ),
            SubjectMastery(
                subject=SubjectCategory.EVS,
                score_percentage=80.0,
                mastery_level="Proficient",
                topics_mastered=["Human Body"],
                topics_needing_improvement=["Plant Life"],
            ),
        ]

        overall = sum(m.score_percentage for m in subject_masteries) / len(subject_masteries)

        learning_gaps = [
            LearningGapIndicator(
                subject=SubjectCategory.MATH,
                topic="Pattern Recognition",
                severity=GapSeverity.LOW,
                gap_description="Child takes slightly longer on skipping numbers by 2.",
                recommended_action="Practice skip counting in Math Jungle.",
            ),
            LearningGapIndicator(
                subject=SubjectCategory.ENGLISH,
                topic="Plurals",
                severity=GapSeverity.MEDIUM,
                gap_description="Needs guidance distinguishing singular and plural word endings.",
                recommended_action="Practice with Suman Ma'am on simple plural words.",
            ),
        ]

        strengths = [
            "Hindi Vowel & Phonology Mastery",
            "Class 1 Addition Accuracy",
            "EVS Body Parts Identification",
        ]

        return ParentDashboardResponse(
            parent_id=consent.parent_id,
            child_student_id=student_id,
            child_name="Nehal",
            grade_level=1,
            overall_mastery_percentage=round(overall, 1),
            total_learning_hours=12.5,
            total_exams_taken=6,
            subject_mastery=subject_masteries,
            learning_gaps=learning_gaps,
            strengths=strengths,
            consent_settings=consent,
        )

    def update_parent_consent(self, consent: DPDPParentConsent) -> DPDPParentConsent:
        """Updates DPDP/COPPA consent preferences for child data processing."""
        self._consent_db[consent.child_student_id] = consent
        return consent


analytics_service = AnalyticsService()
