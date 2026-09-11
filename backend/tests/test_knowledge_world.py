from fastapi.testclient import TestClient

from backend.app.main import app

client = TestClient(app)


def test_get_knowledge_worlds_endpoint():
    response = client.get("/api/v1/knowledge-world/worlds")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) >= 3
    world_ids = [w["world_id"] for w in data]
    assert "world-math-jungle" in world_ids
    assert "world-word-world" in world_ids
    assert "world-science-safari" in world_ids


def test_get_quest_details_endpoint():
    response = client.get("/api/v1/knowledge-world/quest/quest-math-01")
    assert response.status_code == 200
    data = response.json()
    assert data["quest_id"] == "quest-math-01"
    assert data["world_id"] == "world-math-jungle"
    assert len(data["nodes"]) >= 2


def test_get_quest_node_endpoint():
    response = client.get("/api/v1/knowledge-world/quest/quest-math-01/node/node-m1-01")
    assert response.status_code == 200
    data = response.json()
    assert data["node_id"] == "node-m1-01"
    assert "Raja Monkey" in data["story_prompt"]
    assert len(data["choice_options"]) == 2


def test_complete_quest_node_and_badge_unlock():
    student_id = "test-student-kw-01"

    # Step 1: Submit node-m1-01 choice
    payload1 = {
        "student_id": student_id,
        "quest_id": "quest-math-01",
        "node_id": "node-m1-01",
        "selected_choice_id": "opt-m1-01a",
        "time_spent_seconds": 5.0,
    }
    resp1 = client.post("/api/v1/knowledge-world/complete-node", json=payload1)
    assert resp1.status_code == 200
    d1 = resp1.json()
    assert d1["success"] is True
    assert d1["xp_earned"] == 20
    assert d1["total_xp"] == 20
    assert d1["next_node_id"] == "node-m1-02"
    assert d1["is_quest_completed"] is False
    # Badge threshold for badge-first-step is 10 XP
    badge_ids_1 = [b["badge_id"] for b in d1["new_badges_unlocked"]]
    assert "badge-first-step" in badge_ids_1

    # Step 2: Submit node-m1-02 choice
    payload2 = {
        "student_id": student_id,
        "quest_id": "quest-math-01",
        "node_id": "node-m1-02",
        "selected_choice_id": "opt-m1-02a",
        "time_spent_seconds": 4.0,
    }
    resp2 = client.post("/api/v1/knowledge-world/complete-node", json=payload2)
    assert resp2.status_code == 200
    d2 = resp2.json()
    assert d2["success"] is True
    assert d2["xp_earned"] == 25
    assert d2["total_xp"] == 45
    assert d2["next_node_id"] is None
    assert d2["is_quest_completed"] is True
    # Badge threshold for badge-math-star is 30 XP
    badge_ids_2 = [b["badge_id"] for b in d2["new_badges_unlocked"]]
    assert "badge-math-star" in badge_ids_2


def test_student_progress_endpoint():
    student_id = "test-student-progress-01"
    res = client.get(f"/api/v1/knowledge-world/progress/{student_id}")
    assert res.status_code == 200
    data = res.json()
    assert data["student_id"] == student_id
    assert "total_xp" in data
    assert "level" in data
