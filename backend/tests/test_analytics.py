from fastapi.testclient import TestClient

from backend.app.main import app

client = TestClient(app)


def test_generate_exam_post():
    response = client.post(
        "/api/v1/analytics/generate-exam",
        json={
            "student_id": "test-std-01",
            "grade_level": 1,
            "subject": "math",
            "exam_type": "diagnostic",
            "num_questions": 3,
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert "exam_id" in data
    assert data["target_grade"] == 1
    assert data["subject"] == "math"
    assert data["allow_ai_hints"] is False
    assert data["is_timed_quiz"] is True
    assert len(data["questions"]) > 0


def test_generate_exam_get():
    response = client.get(
        "/api/v1/analytics/generate-exam",
        params={
            "student_id": "test-std-01",
            "grade_level": 1,
            "subject": "hindi",
            "exam_type": "diagnostic",
            "num_questions": 2,
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["subject"] == "hindi"
    assert len(data["questions"]) > 0


def test_submit_exam_and_evaluation():
    # First generate a math exam
    gen_res = client.get(
        "/api/v1/analytics/generate-exam",
        params={
            "student_id": "test-std-02",
            "grade_level": 1,
            "subject": "math",
            "num_questions": 2,
        },
    )
    exam = gen_res.json()
    q1 = exam["questions"][0]

    sub_res = client.post(
        "/api/v1/analytics/submit-exam",
        json={
            "student_id": "test-std-02",
            "exam_id": exam["exam_id"],
            "grade_level": 1,
            "subject": "math",
            "answers": [
                {
                    "question_id": q1["question_id"],
                    "answer_text": q1["correct_answer"],
                    "selected_option_id": q1["correct_answer"],
                    "time_spent_seconds": 12.5,
                }
            ],
        },
    )
    assert sub_res.status_code == 200
    sub_data = sub_res.json()
    assert sub_data["total_score"] > 0
    assert sub_data["percentage"] > 0.0
    assert sub_data["ai_hints_used"] == 0
    assert "suresh_analysis" in sub_data
    assert "submission_id" in sub_data
    assert len(sub_data["question_evaluations"]) == 1


def test_parent_dashboard_and_privacy():
    response = client.get(
        "/api/v1/analytics/parent-dashboard",
        params={"student_id": "std-privacy-check", "parent_id": "parent-101"},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["child_student_id"] == "std-privacy-check"
    assert data["overall_mastery_percentage"] >= 0.0
    assert len(data["subject_mastery"]) > 0
    assert data["subject_mastery"][0]["accuracy_rate"] >= 0.0
    assert data["subject_mastery"][0]["time_spent_minutes"] >= 0.0
    assert len(data["suresh_ai_insights"]) > 0
    assert "weekly_summary" in data
    assert data["weekly_summary"]["active_days_count"] >= 1
    assert len(data["learning_gaps"]) > 0
    assert "consent_settings" in data
    assert data["consent_settings"]["dpdp_consent_granted"] is True


def test_update_parent_consent():
    response = client.post(
        "/api/v1/analytics/parent-consent",
        json={
            "parent_id": "parent-101",
            "child_student_id": "std-privacy-check",
            "dpdp_consent_granted": True,
            "coppa_consent_granted": True,
            "allow_voice_data_processing": True,
            "allow_analytics_aggregation": True,
            "data_retention_days": 60,
            "consent_status": "granted",
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["allow_voice_data_processing"] is True
    assert data["data_retention_days"] == 60
