from typing import Dict, List, Optional

from backend.app.schemas.curriculum import (
    AssessmentItem,
    Concept,
    CurriculumVersion,
    ExerciseItem,
    ExerciseType,
    LearningOutcome,
    LessonBlueprint,
    Subject,
    SubjectCode,
    Subtopic,
    Topic,
)

CURRICULUM_VERSION = CurriculumVersion(
    version="1.0.0",
    release_date="2026-09-11",
    grade_level=1,
    cbse_compliant=True,
    supported_subjects=[
        SubjectCode.ENGLISH,
        SubjectCode.HINDI,
        SubjectCode.MARATHI,
        SubjectCode.MATHEMATICS,
        SubjectCode.EVS_GK,
    ],
)

CLASS_1_SUBJECTS: Dict[SubjectCode, Subject] = {
    SubjectCode.ENGLISH: Subject(
        id="sub-eng-c1",
        code=SubjectCode.ENGLISH,
        title_en="English Learning",
        title_native="English",
        description="Foundational English phonics, alphabet recognition, and sight words",
        language="en",
        grade_level=1,
        topics=[
            Topic(
                id="top-eng-01",
                title="Alphabet & Phonics",
                sequence_order=1,
                subtopics=[
                    Subtopic(
                        id="subtop-eng-01-01",
                        title="Vowels & Letter Sounds",
                        sequence_order=1,
                        concepts=[
                            Concept(
                                id="con-eng-01",
                                title="Short Vowel 'A'",
                                explanation="Letter 'A' makes the 'ah' sound as in Apple and Cat.",
                                visual_cues=["Bright red apple icon", "Cat stretching graphic"],
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-eng-01",
                                        outcome_code="CBSE-C1-ENG-01",
                                        description="Identify short vowel sounds in CVC words",
                                        blooms_level="Remember & Understand",
                                        understanding_first_principle=(
                                            "Phonemic awareness connects shapes with sounds."
                                        ),
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-eng-01",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="Which word starts with the short vowel 'A' sound?",
                                options=["Apple", "Ball", "Dog", "Fish"],
                                correct_answer="Apple",
                                hint="Think of the fruit that is red and crunchy!",
                                explanation="'Apple' begins with the letter 'A' sound /æ/.",
                            )
                        ],
                    )
                ],
            )
        ],
    ),
    SubjectCode.HINDI: Subject(
        id="sub-hnd-c1",
        code=SubjectCode.HINDI,
        title_en="Hindi Learning",
        title_native="हिंदी शिक्षण",
        description="सीखें स्वर, व्यंजन और शुरुआती शब्द रचना (Class 1 Hindi CBSE)",
        language="hi",
        grade_level=1,
        topics=[
            Topic(
                id="top-hnd-01",
                title="स्वर पहचान (Vowels)",
                sequence_order=1,
                subtopics=[
                    Subtopic(
                        id="subtop-hnd-01-01",
                        title="अ और आ की मात्रा",
                        sequence_order=1,
                        concepts=[
                            Concept(
                                id="con-hnd-01",
                                title="अ से अनार",
                                explanation="'अ' हिंदी वर्णमाला का पहला स्वर है। जैसे अ से अनार।",
                                visual_cues=["अनार का चित्र", "अ वर्णमाला कार्ड"],
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-hnd-01",
                                        outcome_code="CBSE-C1-HND-01",
                                        description="Recognize and pronounce Hindi vowels (Swar)",
                                        blooms_level="Remember",
                                        understanding_first_principle=(
                                            "Visual association between character and object."
                                        ),
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-hnd-01",
                                type=ExerciseType.VISUAL_MATCH,
                                question="'अ' से शुरू होने वाले शब्द को चुनें:",
                                options=["अनार", "आम", "इमली", "ऊन"],
                                correct_answer="अनार",
                                hint="लाल रंग का मीठा फल!",
                                explanation="'अ' से अनार बनता है।",
                            )
                        ],
                    )
                ],
            )
        ],
    ),
    SubjectCode.MARATHI: Subject(
        id="sub-mar-c1",
        code=SubjectCode.MARATHI,
        title_en="Marathi Learning",
        title_native="मराठी अध्ययन",
        description="मूलभूत मराठी मुळाक्षरे आणि प्राथमिक शब्द (Class 1 Marathi)",
        language="mr",
        grade_level=1,
        topics=[
            Topic(
                id="top-mar-01",
                title="मराठी स्वर (Marathi Vowels)",
                sequence_order=1,
                subtopics=[
                    Subtopic(
                        id="subtop-mar-01-01",
                        title="अ आणि आ ची ओळख",
                        sequence_order=1,
                        concepts=[
                            Concept(
                                id="con-mar-01",
                                title="अ - अननस",
                                explanation="'अ' हे मराठी मुळाक्षरांमधील पहिले अक्षर आहे. अ वरून अननस.",
                                visual_cues=["अननसाचे चित्र", "अ अक्षर"],
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-mar-01",
                                        outcome_code="CBSE-C1-MAR-01",
                                        description="Recognize initial Marathi Swar characters",
                                        blooms_level="Remember",
                                        understanding_first_principle=(
                                            "Phonetic resonance in primary mother tongue."
                                        ),
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-mar-01",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="'अ' अक्षरापासून सुरू होणारा शब्द कोणता?",
                                options=["अननस", "आंबा", "इमारत", "ओढणी"],
                                correct_answer="अननस",
                                hint="काटेरी आणि गोड फळ!",
                                explanation="अ - अननस बरोबर उत्तर आहे.",
                            )
                        ],
                    )
                ],
            )
        ],
    ),
    SubjectCode.MATHEMATICS: Subject(
        id="sub-mth-c1",
        code=SubjectCode.MATHEMATICS,
        title_en="Mathematics",
        title_native="गणित",
        description="Counting, numbers 1 to 20, basic shapes, and spatial understanding",
        language="en",
        grade_level=1,
        topics=[
            Topic(
                id="top-mth-01",
                title="Numbers 1 to 9 & Zero",
                sequence_order=1,
                subtopics=[
                    Subtopic(
                        id="subtop-mth-01-01",
                        title="Counting Objects",
                        sequence_order=1,
                        concepts=[
                            Concept(
                                id="con-mth-01",
                                title="Counting 1 to 5",
                                explanation="We use counting to find out 'how many' items.",
                                visual_cues=["5 bright stars", "Hand showing 5 fingers"],
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-mth-01",
                                        outcome_code="CBSE-C1-MTH-01",
                                        description="Count concrete objects up to 9 accurately",
                                        blooms_level="Apply",
                                        understanding_first_principle=(
                                            "One-to-one correspondence in counting objects."
                                        ),
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-mth-01",
                                type=ExerciseType.FILL_IN_BLANK,
                                question="How many stars are there: ★ ★ ★ ?",
                                options=["2", "3", "4", "5"],
                                correct_answer="3",
                                hint="Count them one by one: one, two, ...",
                                explanation="There are 3 stars in the group.",
                            )
                        ],
                    )
                ],
            )
        ],
    ),
    SubjectCode.EVS_GK: Subject(
        id="sub-gk-c1",
        code=SubjectCode.EVS_GK,
        title_en="Environmental Studies & General Knowledge",
        title_native="पर्यावरण व सामान्य ज्ञान",
        description="Discovering myself, my family, animals, plants, and safety rules for Class 1",
        language="en",
        grade_level=1,
        topics=[
            Topic(
                id="top-gk-01",
                title="About Me & My Body",
                sequence_order=1,
                subtopics=[
                    Subtopic(
                        id="subtop-gk-01-01",
                        title="My Body Parts & Sense Organs",
                        sequence_order=1,
                        concepts=[
                            Concept(
                                id="con-gk-01",
                                title="Five Sense Organs",
                                explanation=(
                                    "We have 5 sense organs: eyes, ears, nose, tongue, and skin."
                                ),
                                visual_cues=["Diagram of face with sense organ callouts"],
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-gk-01",
                                        outcome_code="CBSE-C1-GK-01",
                                        description="Identify human sense organs and functions",
                                        blooms_level="Understand",
                                        understanding_first_principle=(
                                            "Self-awareness and sensory observation."
                                        ),
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-gk-01",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="Which sense organ helps us hear music?",
                                options=["Ears", "Eyes", "Nose", "Tongue"],
                                correct_answer="Ears",
                                hint="They are on the sides of your head!",
                                explanation="We listen and hear sounds using our ears.",
                            )
                        ],
                    )
                ],
            )
        ],
    ),
}

LESSON_BLUEPRINTS: Dict[str, LessonBlueprint] = {
    "les-eng-01": LessonBlueprint(
        id="les-eng-01",
        subject_code=SubjectCode.ENGLISH,
        grade_level=1,
        title="Fun with Short Vowel A",
        topic_id="top-eng-01",
        subtopic_id="subtop-eng-01-01",
        concepts=[CLASS_1_SUBJECTS[SubjectCode.ENGLISH].topics[0].subtopics[0].concepts[0]],
        assessment_items=[
            AssessmentItem(
                id="asm-eng-01",
                exercise=CLASS_1_SUBJECTS[SubjectCode.ENGLISH].topics[0].subtopics[0].exercises[0],
                weightage=1.0,
            )
        ],
        curriculum_version="1.0.0",
    ),
    "les-hnd-01": LessonBlueprint(
        id="les-hnd-01",
        subject_code=SubjectCode.HINDI,
        grade_level=1,
        title="अक्षर 'अ' की पहचान",
        topic_id="top-hnd-01",
        subtopic_id="subtop-hnd-01-01",
        concepts=[CLASS_1_SUBJECTS[SubjectCode.HINDI].topics[0].subtopics[0].concepts[0]],
        assessment_items=[
            AssessmentItem(
                id="asm-hnd-01",
                exercise=CLASS_1_SUBJECTS[SubjectCode.HINDI].topics[0].subtopics[0].exercises[0],
                weightage=1.0,
            )
        ],
        curriculum_version="1.0.0",
    ),
    "les-mar-01": LessonBlueprint(
        id="les-mar-01",
        subject_code=SubjectCode.MARATHI,
        grade_level=1,
        title="मराठी स्वर 'अ' शिकूया",
        topic_id="top-mar-01",
        subtopic_id="subtop-mar-01-01",
        concepts=[CLASS_1_SUBJECTS[SubjectCode.MARATHI].topics[0].subtopics[0].concepts[0]],
        assessment_items=[
            AssessmentItem(
                id="asm-mar-01",
                exercise=CLASS_1_SUBJECTS[SubjectCode.MARATHI].topics[0].subtopics[0].exercises[0],
                weightage=1.0,
            )
        ],
        curriculum_version="1.0.0",
    ),
    "les-mth-01": LessonBlueprint(
        id="les-mth-01",
        subject_code=SubjectCode.MATHEMATICS,
        grade_level=1,
        title="Let's Count Objects 1 to 5",
        topic_id="top-mth-01",
        subtopic_id="subtop-mth-01-01",
        concepts=[CLASS_1_SUBJECTS[SubjectCode.MATHEMATICS].topics[0].subtopics[0].concepts[0]],
        assessment_items=[
            AssessmentItem(
                id="asm-mth-01",
                exercise=(
                    CLASS_1_SUBJECTS[SubjectCode.MATHEMATICS].topics[0].subtopics[0].exercises[0]
                ),
                weightage=1.0,
            )
        ],
        curriculum_version="1.0.0",
    ),
    "les-gk-01": LessonBlueprint(
        id="les-gk-01",
        subject_code=SubjectCode.EVS_GK,
        grade_level=1,
        title="My Sense Organs",
        topic_id="top-gk-01",
        subtopic_id="subtop-gk-01-01",
        concepts=[CLASS_1_SUBJECTS[SubjectCode.EVS_GK].topics[0].subtopics[0].concepts[0]],
        assessment_items=[
            AssessmentItem(
                id="asm-gk-01",
                exercise=CLASS_1_SUBJECTS[SubjectCode.EVS_GK].topics[0].subtopics[0].exercises[0],
                weightage=1.0,
            )
        ],
        curriculum_version="1.0.0",
    ),
}


class CurriculumService:
    @staticmethod
    def get_version() -> CurriculumVersion:
        return CURRICULUM_VERSION

    @staticmethod
    def get_all_subjects() -> List[Subject]:
        return list(CLASS_1_SUBJECTS.values())

    @staticmethod
    def get_subject_by_code(code: SubjectCode) -> Optional[Subject]:
        return CLASS_1_SUBJECTS.get(code)

    @staticmethod
    def get_topic_by_id(topic_id: str) -> Optional[Topic]:
        for subject in CLASS_1_SUBJECTS.values():
            for topic in subject.topics:
                if topic.id == topic_id:
                    return topic
        return None

    @staticmethod
    def get_lesson_blueprint(lesson_id: str) -> Optional[LessonBlueprint]:
        return LESSON_BLUEPRINTS.get(lesson_id)
