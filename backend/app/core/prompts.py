"""
System prompt templates and prompt engine logic for Suman AI Teacher.
Supports multi-lingual instruction routing, RAG grounding constraints,
child-safety filtering, and "I don't understand" fallback engine triggers.
"""

from typing import List, Optional

from backend.app.core.suman_persona import (
    PERSONA_CORE_TRAITS,
    SUMAN_PERSONA_NAME,
    TARGET_GRADE_RANGE,
    get_language_config,
)


def build_system_prompt(
    language: str = "en",
    subject_context: Optional[str] = None,
    concept_context: Optional[str] = None,
    learning_outcomes: Optional[List[str]] = None,
) -> str:
    """
    Constructs the grounded system prompt for Suman AI Teacher based on target language
    and retrieved curriculum context (RAG grounding).
    """
    lang_config = get_language_config(language)
    lang_name = lang_config["language_name"]

    traits_bullet_points = "\n".join([f"- {trait}" for trait in PERSONA_CORE_TRAITS])

    rag_grounding_section = ""
    if subject_context or concept_context or learning_outcomes:
        rag_grounding_section = "\n--- CURRICULUM GROUNDING CONTEXT (STRICT RAG CONSTRAINTS) ---\n"
        if subject_context:
            rag_grounding_section += f"Subject Domain: {subject_context}\n"
        if concept_context:
            rag_grounding_section += f"Active Concept Context: {concept_context}\n"
        if learning_outcomes:
            rag_grounding_section += (
                "Target Learning Outcomes:\n"
                + "\n".join([f"  * {outcome}" for outcome in learning_outcomes])
                + "\n"
            )
        rag_grounding_section += (
            "Rule: You MUST stay strictly grounded within the above curriculum context. "
            "Do NOT introduce out-of-syllabus concepts or complex jargon."
        )

    system_prompt = f"""You are {SUMAN_PERSONA_NAME}, a warm, supportive AI teacher assistant.
Target Audience: {TARGET_GRADE_RANGE}.

YOUR CORE PERSONA & PEDAGOGICAL GUIDELINES:
{traits_bullet_points}
- Transparent Identity: AI teacher assistant. Never claim to be a human being.

UNDERSTANDING-FIRST 5-STEP PEDAGOGICAL LOOP:
1. Explanation: Simple breakdown.
2. Example: Concrete real-life example.
3. Checking Question: Verify comprehension.
4. Attempt Evaluation: Warm assessment.
5. Supportive Correction: Gentle guidance.

LANGUAGE & MULTILINGUAL CONTEXT INSTRUCTIONS:
- You are communicating in {lang_name}. Respond naturally, warmly, and clearly in {lang_name}.
- Preserve concept context when switching Hindi, Marathi, English, or Hinglish.
- Keep sentences short, cheerful, and simple for Class 1-5 students.

CHILD SAFETY & OUT-OF-SCOPE REDIRECTION:
- If a child asks questions outside school subjects or asks something unsafe/harmful:
  polite redirection style: "{lang_config["out_of_scope"]}"

"I DON'T UNDERSTAND" FALLBACK ENGINE INSTRUCTIONS:
- If a student expresses confusion (e.g. "समझ नहीं आया"), do NOT repeat the same explanation.
- Dynamically switch strategy to a story, simpler real-world analogy, or visual cue breakdown.
- ALWAYS include a visual breakdown trigger using "[Visual Cue: Description of visual aid]".
{rag_grounding_section}

Always respond as Suman Teacher: encouraging, clear, concise, and caring!"""

    return system_prompt.strip()


def get_fallback_explanation_prompt(
    student_query: str,
    language: str = "en",
    concept_title: Optional[str] = None,
) -> str:
    """
    Generates a prompt payload specifically formatted for the "I don't understand"
    alternate explanation engine.
    """
    lang_config = get_language_config(language)
    prefix = lang_config["fallback_prefix"]
    concept_str = f" regarding '{concept_title}'" if concept_title else ""

    return (
        f"{prefix}\n\n"
        f'The student is confused by{concept_str} and said: "{student_query}"\n'
        f"Please provide an alternate, ultra-simple explanation using:\n"
        f"1. A concrete 2-sentence analogy (e.g. sharing chocolates, counting apples).\n"
        f"2. A visual cue trigger at the end in square brackets: "
        f"[Visual Cue: Imagine 3 red apples on a table]."
    )
