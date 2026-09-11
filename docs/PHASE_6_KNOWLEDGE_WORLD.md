# Phase 6 — Knowledge World & Gamified Story Engine Architecture

## Overview
Phase 6 introduces the Knowledge World and Gamified Story Engine Architecture for **Nehal Ki Teacher AI**, designed to engage primary school students (KG to Class 5, priority Class 1) through understanding-first learning quests across core themes.

## Key Components

### 1. World Themes
- **Math Jungle (`world-math-jungle`)**: Counting, basic arithmetic, shapes, and patterns alongside Raja Monkey.
- **Word World (`world-word-world`)**: Phonics, vocabulary, rhyming words, and basic reading with Suman Teacher.
- **Science Safari (`world-science-safari`)**: Exploration of nature, animals, plants, and water cycles across India with Suresh Teacher.

### 2. Story Quests & Interactive Nodes
- **Branching Choice Nodes**: Students make understanding-first choices in story quests.
- **Dialogue & Persona**: Integrated dialogues from Suman and Suresh AI Teachers.
- **Non-monetary Gamification**: XP points, level progression, stars, and non-monetary badges.

### 3. Non-Monetary Reward System & Badges
- **First Explorer (`badge-first-step`)**: Awarded upon completing the first quest node.
- **Math Jungle Star (`badge-math-star`)**: Awarded upon earning 30+ XP in Math Jungle.
- **Word Wizard (`badge-word-wizard`)**: Awarded upon earning 50+ XP in Word World.

### 4. Child Safety & Ethics Guidelines
- **Zero Microtransactions**: Absolute prohibition of real-money paywalls, microtransactions, loot boxes, or dark patterns.
- **Encouraging Feedback**: Always gentle, supportive, and focused on learning progress.

### 5. API Endpoints
- `GET /api/v1/knowledge-world/worlds`: List all available learning worlds and progress trees.
- `GET /api/v1/knowledge-world/quest/{quest_id}`: Get full quest details and nodes.
- `GET /api/v1/knowledge-world/quest/{quest_id}/node/{node_id}`: Get specific interactive node.
- `POST /api/v1/knowledge-world/complete-node`: Submit student choice, calculate XP, and unlock badges.
- `GET /api/v1/knowledge-world/progress/{student_id}`: Fetch student's gamified profile and progress.

### 6. Mobile Flutter Integration
- Data models defined in `mobile/lib/models/knowledge_world.dart`.
- Service layer defined in `mobile/lib/services/knowledge_world_service.dart` with local offline fallbacks.
