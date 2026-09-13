from typing import Dict, List, Optional

from backend.app.schemas.curriculum import (
    AssessmentItem,
    Concept,
    CurriculumVersion,
    DailyPracticeReminder,
    ExerciseItem,
    ExerciseType,
    LearningOutcome,
    LessonBlueprint,
    ProgressUpdateRequest,
    RevisionPrompt,
    StudyProgressTrack,
    Subject,
    SubjectCode,
    Subtopic,
    SureshStudyGuideSummary,
    Topic,
)

CURRICULUM_VERSION = CurriculumVersion(
    version="1.0.0",
    release_date="2026-09-11",
    grade_level=1,
    cbse_compliant=True,
    cbse_academic_year="2026-27",
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
        description="English phonics, sight words, CVC words, simple sentences",
        language="en",
        grade_level=1,
        cbse_academic_year="2026-27",
        topics=[
            Topic(
                id="top-eng-01",
                title="Alphabet & Phonics",
                sequence_order=1,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-eng-01-01",
                        title="Vowels & Letter Sounds",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-eng-01",
                                title="Short Vowel 'A'",
                                explanation="Letter 'A' makes the 'ah' sound as in Apple and Cat.",
                                visual_cues=["Bright red apple icon", "Cat stretching graphic"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-eng-01",
                                        outcome_code="CBSE-C1-ENG-01",
                                        description="Identify short vowel sounds in CVC words",
                                        blooms_level="Remember & Understand",
                                        understanding_first_principle=(
                                            "Phonemic awareness connects shapes with sounds."
                                        ),
                                        cbse_academic_year="2026-27",
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
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-eng-02",
                title="Sight Words Recognition",
                sequence_order=2,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-eng-02-01",
                        title="High-Frequency Sight Words",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-eng-02",
                                title="Sight Words: The, Is, And",
                                explanation="Sight words are common words we read quickly.",
                                visual_cues=["Word cards for 'THE', 'IS', 'AND'"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-eng-02",
                                        outcome_code="CBSE-C1-ENG-02",
                                        description="Recognize foundational sight words instantly",
                                        blooms_level="Remember",
                                        understanding_first_principle=(
                                            "Visual pattern recognition speeds up reading fluency."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-eng-02",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="Choose sight word: '__ cat is on the mat.'",
                                options=["The", "And", "In", "On"],
                                correct_answer="The",
                                hint="Word that points to a specific cat!",
                                explanation="'The' starts the sentence correctly.",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-eng-03",
                title="Small CVC Words",
                sequence_order=3,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-eng-03-01",
                        title="Blending 3-Letter CVC Words",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-eng-03",
                                title="Building Words: CAT, BAT, MAT",
                                explanation="CVC words blend three sounds together.",
                                visual_cues=["Bat and ball illustration", "Playful cat"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-eng-03",
                                        outcome_code="CBSE-C1-ENG-03",
                                        description="Blend 3-letter CVC words accurately",
                                        blooms_level="Apply",
                                        understanding_first_principle=(
                                            "Phonic synthesis forms early word building."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-eng-03",
                                type=ExerciseType.FILL_IN_BLANK,
                                question="Fill in the missing letter: B _ T",
                                options=["A", "E", "I", "O"],
                                correct_answer="A",
                                hint="Sound is /æ/",
                                explanation="B + A + T makes BAT.",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-eng-04",
                title="Simple Sentence Reading",
                sequence_order=4,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-eng-04-01",
                        title="Reading 3 to 4 Word Sentences",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-eng-04",
                                title="Simple Sentences: 'This is a dog'",
                                explanation="A simple sentence combines words to share an idea.",
                                visual_cues=["Happy puppy waging tail"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-eng-04",
                                        outcome_code="CBSE-C1-ENG-04",
                                        description="Read simple 3-4 word sentences aloud",
                                        blooms_level="Apply & Understand",
                                        understanding_first_principle=(
                                            "Sentence comprehension builds communication."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-eng-04",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="Complete sentence: 'This is a red ______.'",
                                options=["apple", "run", "jump", "sky"],
                                correct_answer="apple",
                                hint="A red juicy fruit!",
                                explanation="An apple is red, so 'This is a red apple' works.",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
        ],
    ),
    SubjectCode.HINDI: Subject(
        id="sub-hnd-c1",
        code=SubjectCode.HINDI,
        title_en="Hindi Learning",
        title_native="हिंदी शिक्षण",
        description="वर्णमाला (स्वर, व्यंजन), मात्राएँ, छोटे शब्द और सरल वाक्य पठन",
        language="hi",
        grade_level=1,
        cbse_academic_year="2026-27",
        topics=[
            Topic(
                id="top-hnd-01",
                title="वर्णमाला (स्वर और व्यंजन)",
                sequence_order=1,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-hnd-01-01",
                        title="स्वर पहचान (अ से अः)",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-hnd-01",
                                title="अ से अनार और आ से आम",
                                explanation="'अ' और 'आ' हिंदी वर्णमाला के स्वर हैं। अ से अनार।",
                                visual_cues=["अनार का चित्र", "रसीले आम का चित्र"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-hnd-01",
                                        outcome_code="CBSE-C1-HND-01",
                                        description="Recognize and pronounce Hindi vowels",
                                        blooms_level="Remember",
                                        understanding_first_principle=(
                                            "Visual association between character and object."
                                        ),
                                        cbse_academic_year="2026-27",
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
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-hnd-02",
                title="मात्राएँ (Matras)",
                sequence_order=2,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-hnd-02-01",
                        title="आ (ा) और इ (ि) की मात्रा",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-hnd-02",
                                title="आ की मात्रा (ा) जैसे 'काम' और 'नाम'",
                                explanation="व्यंजन के साथ मात्रा जोड़ने पर नया शब्द बनता है।",
                                visual_cues=["काम और आम का चित्र"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-hnd-02",
                                        outcome_code="CBSE-C1-HND-02",
                                        description="Apply basic Matras to Hindi consonants",
                                        blooms_level="Apply",
                                        understanding_first_principle=(
                                            "Matra integration modifies consonant pitch."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-hnd-02",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="'क + ा' मिलाकर क्या बनेगा?",
                                options=["का", "की", "कू", "के"],
                                correct_answer="का",
                                hint="क के आगे आ की मात्रा लगी है!",
                                explanation="'क' के साथ 'ा' जोड़ने पर 'का' बनता है।",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-hnd-03",
                title="छोटे अमात्रिक शब्द",
                sequence_order=3,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-hnd-03-01",
                        title="दो और तीन अक्षरों के शब्द (घर, फल, कमल)",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-hnd-03",
                                title="अमात्रिक शब्द: घ + र = घर",
                                explanation="बिना मात्रा के अक्षरों को जोड़कर बनने वाले शब्द।",
                                visual_cues=["प्यारा सा घर", "सुंदर कमल का फूल"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-hnd-03",
                                        outcome_code="CBSE-C1-HND-03",
                                        description="Combine consonants into non-matra words",
                                        blooms_level="Apply",
                                        understanding_first_principle=(
                                            "Letter concatenation builds early vocabulary."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-hnd-03",
                                type=ExerciseType.FILL_IN_BLANK,
                                question="'घ + र' जोड़ने से कौन सा शब्द बनता है?",
                                options=["घर", "रथ", "जल", "नल"],
                                correct_answer="घर",
                                hint="जहाँ हम सब रहते हैं!",
                                explanation="घ और र मिलकर 'घर' बनता है।",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-hnd-04",
                title="सरल वाक्य पठन",
                sequence_order=4,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-hnd-04-01",
                        title="छोटे वाक्यों का उच्चारण और अर्थ",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-hnd-04",
                                title="सरल वाक्य: 'घर चल', 'जल भर'",
                                explanation="छोटे-छोटे शब्दों को मिलाकर वाक्य बनता है।",
                                visual_cues=["घर की ओर जाता बच्चा"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-hnd-04",
                                        outcome_code="CBSE-C1-HND-04",
                                        description="Read simple Hindi two-word sentences",
                                        blooms_level="Understand",
                                        understanding_first_principle=(
                                            "Sentence synthesis promotes natural reading."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-hnd-04",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="'नल पर चलकर ____ भर।'",
                                options=["जल", "फल", "थल", "कल"],
                                correct_answer="जल",
                                hint="पीने का पानी!",
                                explanation="नल पर जल भरा जाता है, इसलिए 'जल' सही है।",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
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
        cbse_academic_year="2026-27",
        topics=[
            Topic(
                id="top-mar-01",
                title="मराठी स्वर (Marathi Vowels)",
                sequence_order=1,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-mar-01-01",
                        title="अ आणि आ ची ओळख",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-mar-01",
                                title="अ - अननस",
                                explanation="'अ' हे मराठी मुळाक्षरांमधील पहिले अक्षर आहे.",
                                visual_cues=["अननसाचे चित्र", "अ अक्षर"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-mar-01",
                                        outcome_code="CBSE-C1-MAR-01",
                                        description="Recognize initial Marathi Swar characters",
                                        blooms_level="Remember",
                                        understanding_first_principle=(
                                            "Phonetic resonance in primary mother tongue."
                                        ),
                                        cbse_academic_year="2026-27",
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
                                cbse_academic_year="2026-27",
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
        description="Counting, Addition, Subtraction, Shapes, Patterns, Spatial Awareness",
        language="en",
        grade_level=1,
        cbse_academic_year="2026-27",
        topics=[
            Topic(
                id="top-mth-01",
                title="Counting & Numbers 1 to 20",
                sequence_order=1,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-mth-01-01",
                        title="Counting Objects 1 to 10",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-mth-01",
                                title="Counting 1 to 5",
                                explanation="We use counting to find out 'how many' items.",
                                visual_cues=["5 bright stars", "Hand showing 5 fingers"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-mth-01",
                                        outcome_code="CBSE-C1-MTH-01",
                                        description="Count concrete objects up to 10 accurately",
                                        blooms_level="Apply",
                                        understanding_first_principle=(
                                            "One-to-one correspondence in counting objects."
                                        ),
                                        cbse_academic_year="2026-27",
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
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-mth-02",
                title="Single-digit Addition",
                sequence_order=2,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-mth-02-01",
                        title="Combining Collections (Addition within 10)",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-mth-02",
                                title="Adding Two Groups: 2 + 3 = 5",
                                explanation="Addition means joining two groups to find total.",
                                visual_cues=["2 red apples + 3 green apples"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-mth-02",
                                        outcome_code="CBSE-C1-MTH-02",
                                        description="Add single-digit numbers up to 10",
                                        blooms_level="Apply",
                                        understanding_first_principle=(
                                            "Combining concrete sets leads to arithmetic."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-mth-02",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="What is 2 + 3?",
                                options=["4", "5", "6", "7"],
                                correct_answer="5",
                                hint="Count 2 fingers on left and 3 on right!",
                                explanation="2 plus 3 equals 5.",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-mth-03",
                title="Single-digit Subtraction",
                sequence_order=3,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-mth-03-01",
                        title="Taking Away Objects (Subtraction within 10)",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-mth-03",
                                title="Taking Away: 5 - 2 = 3",
                                explanation="Subtraction means taking items away from a group.",
                                visual_cues=["5 balloons, 2 fly away, leaving 3"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-mth-03",
                                        outcome_code="CBSE-C1-MTH-03",
                                        description="Subtract single-digit numbers up to 10",
                                        blooms_level="Apply",
                                        understanding_first_principle=(
                                            "Take-away model grounds subtraction."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-mth-03",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="If you have 5 candies and eat 2, how many left?",
                                options=["1", "2", "3", "4"],
                                correct_answer="3",
                                hint="Count backward from 5 by 2 steps!",
                                explanation="5 minus 2 leaves 3 candies.",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-mth-04",
                title="Basic 2D & 3D Shapes",
                sequence_order=4,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-mth-04-01",
                        title="Circle, Square, Triangle, Rectangle",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-mth-04",
                                title="Properties of Shapes",
                                explanation="A circle is round and a triangle has 3 sides.",
                                visual_cues=["Wheel (circle)", "Slice of pizza (triangle)"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-mth-04",
                                        outcome_code="CBSE-C1-MTH-04",
                                        description="Identify basic geometric shapes",
                                        blooms_level="Remember & Understand",
                                        understanding_first_principle=(
                                            "Spatial geometry anchors abstract shapes."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-mth-04",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="Which shape has 3 sides?",
                                options=["Square", "Triangle", "Circle", "Rectangle"],
                                correct_answer="Triangle",
                                hint="Think of a slice of pizza!",
                                explanation="A triangle has 3 sides and 3 corners.",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-mth-05",
                title="Pattern Recognition",
                sequence_order=5,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-mth-05-01",
                        title="Repeating Shape and Number Patterns",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-mth-05",
                                title="Repeating Patterns: Red, Blue, Red, Blue",
                                explanation="A pattern is something that repeats in order.",
                                visual_cues=["🔴 🔵 🔴 🔵 🔴 ❓"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-mth-05",
                                        outcome_code="CBSE-C1-MTH-05",
                                        description="Complete simple repeating sequences",
                                        blooms_level="Analyze & Apply",
                                        understanding_first_principle=(
                                            "Sequential order builds algebraic thinking."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-mth-05",
                                type=ExerciseType.FILL_IN_BLANK,
                                question="What comes next in the pattern: 1, 2, 1, 2, __?",
                                options=["1", "2", "3", "0"],
                                correct_answer="1",
                                hint="The pattern repeats 1 then 2!",
                                explanation="After 2, the pattern repeats back to 1.",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
            Topic(
                id="top-mth-06",
                title="Spatial Awareness & Positions",
                sequence_order=6,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-mth-06-01",
                        title="Top / Bottom, Inside / Outside, On / Under",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-mth-06",
                                title="Spatial Words: Top, Bottom, Inside, Outside",
                                explanation="Spatial words describe where things are located.",
                                visual_cues=["Cat sitting on a table vs under a table"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-mth-06",
                                        outcome_code="CBSE-C1-MTH-06",
                                        description="Understand spatial positioning terms",
                                        blooms_level="Understand",
                                        understanding_first_principle=(
                                            "Positional vocabulary develops spatial reasoning."
                                        ),
                                        cbse_academic_year="2026-27",
                                    )
                                ],
                            )
                        ],
                        exercises=[
                            ExerciseItem(
                                id="ex-mth-06",
                                type=ExerciseType.MULTIPLE_CHOICE,
                                question="Where is the bird resting on a tree branch?",
                                options=["On top", "Under", "Inside dirt", "Far away"],
                                correct_answer="On top",
                                hint="The bird sits on top!",
                                explanation="The bird is sitting on top of the branch.",
                                cbse_academic_year="2026-27",
                            )
                        ],
                    )
                ],
            ),
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
        cbse_academic_year="2026-27",
        topics=[
            Topic(
                id="top-gk-01",
                title="About Me & My Body",
                sequence_order=1,
                cbse_academic_year="2026-27",
                subtopics=[
                    Subtopic(
                        id="subtop-gk-01-01",
                        title="My Body Parts & Sense Organs",
                        sequence_order=1,
                        cbse_academic_year="2026-27",
                        concepts=[
                            Concept(
                                id="con-gk-01",
                                title="Five Sense Organs",
                                explanation=(
                                    "We have 5 sense organs: eyes, ears, nose, tongue, and skin."
                                ),
                                visual_cues=["Diagram of face with sense organ callouts"],
                                cbse_academic_year="2026-27",
                                learning_outcomes=[
                                    LearningOutcome(
                                        id="lo-gk-01",
                                        outcome_code="CBSE-C1-GK-01",
                                        description="Identify human sense organs and functions",
                                        blooms_level="Understand",
                                        understanding_first_principle=(
                                            "Self-awareness and sensory observation."
                                        ),
                                        cbse_academic_year="2026-27",
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
                                cbse_academic_year="2026-27",
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
                cbse_academic_year="2026-27",
            )
        ],
        curriculum_version="1.0.0",
        cbse_academic_year="2026-27",
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
                cbse_academic_year="2026-27",
            )
        ],
        curriculum_version="1.0.0",
        cbse_academic_year="2026-27",
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
                cbse_academic_year="2026-27",
            )
        ],
        curriculum_version="1.0.0",
        cbse_academic_year="2026-27",
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
                cbse_academic_year="2026-27",
            )
        ],
        curriculum_version="1.0.0",
        cbse_academic_year="2026-27",
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
                cbse_academic_year="2026-27",
            )
        ],
        curriculum_version="1.0.0",
        cbse_academic_year="2026-27",
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

    @classmethod
    def get_suresh_study_guide(cls, student_id: str) -> SureshStudyGuideSummary:
        """Suresh AI Study Guide providing progress, reminders, and revision prompts."""
        progress = StudyProgressTrack(
            student_id=student_id,
            completed_concept_ids=["con-mth-01", "con-eng-01", "con-hnd-01"],
            completed_exercise_ids=["ex-mth-01", "ex-eng-01"],
            mastery_percentage=85.0,
            last_active_date="2026-09-11",
        )

        daily_reminders = [
            DailyPracticeReminder(
                reminder_id="rem-01",
                student_id=student_id,
                message="Shabash Nehal! Let's spend 15 min on addition today!",
                recommended_subject=SubjectCode.MATHEMATICS,
                recommended_topic_id="top-mth-02",
                target_minutes=15,
            ),
            DailyPracticeReminder(
                reminder_id="rem-02",
                student_id=student_id,
                message="Read 2 simple sentences with Suman Ma'am before bedtime!",
                recommended_subject=SubjectCode.ENGLISH,
                recommended_topic_id="top-eng-04",
                target_minutes=10,
            ),
        ]

        revision_prompts = [
            RevisionPrompt(
                prompt_id="rev-01",
                student_id=student_id,
                concept_id="con-mth-01",
                prompt_question="Can you quickly count from 1 to 5 out loud?",
                revision_reason="spaced_repetition",
            ),
            RevisionPrompt(
                prompt_id="rev-02",
                student_id=student_id,
                concept_id="con-hnd-01",
                prompt_question="'अ' से कौन सा फल शुरू होता है?",
                revision_reason="spaced_repetition",
            ),
        ]

        return SureshStudyGuideSummary(
            student_id=student_id,
            mentor_name="Suresh Teacher",
            progress=progress,
            daily_reminders=daily_reminders,
            revision_prompts=revision_prompts,
        )

    @classmethod
    def update_study_progress(cls, req: ProgressUpdateRequest) -> SureshStudyGuideSummary:
        """Update progress tracking and return updated Suresh AI Study Guide summary."""
        guide = cls.get_suresh_study_guide(req.student_id)
        if req.concept_id and req.concept_id not in guide.progress.completed_concept_ids:
            guide.progress.completed_concept_ids.append(req.concept_id)
        if req.exercise_id and req.exercise_id not in guide.progress.completed_exercise_ids:
            guide.progress.completed_exercise_ids.append(req.exercise_id)

        done_concepts = len(guide.progress.completed_concept_ids)
        done_exercises = len(guide.progress.completed_exercise_ids)
        total_items = done_concepts + done_exercises
        guide.progress.mastery_percentage = min(100.0, max(50.0, total_items * 15.0))
        return guide
