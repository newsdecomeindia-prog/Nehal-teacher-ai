from backend.app.schemas.teacher import TeacherChatRequest
from backend.app.services.ai_teacher_service import AITeacherService


def test_rich_visual_card_generation():
    req = TeacherChatRequest(
        student_id="s1",
        message="भारत के प्रधानमंत्री कौन हैं?",
        language="hi",
    )
    res = AITeacherService.process_chat_query(req)
    assert res.rich_card is not None
    assert res.rich_card.entity_name == "Narendra Modi"
    assert res.rich_card.titles.english == "Narendra Modi"
    assert res.rich_card.titles.hindi == "नरेंद्र मोदी"
    assert res.rich_card.titles.marathi == "नरेंद्र मोदी"
    assert res.rich_card.class_level == 1
