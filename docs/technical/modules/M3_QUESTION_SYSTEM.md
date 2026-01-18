# Module 3: Question System & Answer Collection

**Timeline**: Weeks 5-6
**Owner**: Backend Lead
**Team**: 1 Backend Engineer
**Dependencies**: Module 1 (Database), Module 2 (Authentication)
**Blocks**: Module 4 (Value Portrait Engine)

---

## Module Overview

This module implements the adaptive question system for onboarding users. It serves questions based on user progress, collects and validates answers, and tracks onboarding completion. The system uses an adaptive algorithm to select questions that maximize confidence in the user's value portrait.

**Success Criteria**:
- Questions API returns appropriate questions for user
- Answers validated and stored correctly
- Progress tracking accurate
- Adaptive algorithm selects optimal questions
- API response time <200ms
- All tests passing (>90% coverage)

---

## Technical Specifications

### API Endpoints

#### 1. Get Next Questions

**Endpoint**: `GET /api/v1/questions`

**Headers**:
```
Authorization: Bearer <jwt_token>
```

**Query Parameters**:
- `batch_size` (optional, default: 1): Number of questions to return

**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "questions": [
      {
        "id": 1,
        "text": "Individual freedom should be prioritized over collective security.",
        "question_type": "direct_value",
        "dimension": {
          "id": 1,
          "key": "liberty_authority",
          "name": "Individual Liberty vs Collective Authority"
        },
        "options": {
          "scale": 5,
          "labels": ["Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree"]
        },
        "position": 1,
        "difficulty": "easy"
      }
    ],
    "progress": {
      "answered": 5,
      "total": 24,
      "percentage": 21,
      "remaining": 19
    },
    "onboarding_complete": false
  }
}
```

**Error Response** (404 Not Found):
```json
{
  "status": "error",
  "message": "No more questions available"
}
```

---

#### 2. Submit Answer

**Endpoint**: `POST /api/v1/answers`

**Headers**:
```
Authorization: Bearer <jwt_token>
```

**Request Body** (Direct Value Question):
```json
{
  "answer": {
    "question_id": 1,
    "answer_data": {
      "value": 4,
      "time_spent_seconds": 15
    }
  }
}
```

**Request Body** (Policy Preference):
```json
{
  "answer": {
    "question_id": 2,
    "answer_data": {
      "value": "left",
      "time_spent_seconds": 20
    }
  }
}
```

**Request Body** (Tradeoff Slider):
```json
{
  "answer": {
    "question_id": 3,
    "answer_data": {
      "value": 65,
      "time_spent_seconds": 30
    }
  }
}
```

**Request Body** (Dilemma):
```json
{
  "answer": {
    "question_id": 4,
    "answer_data": {
      "value": "A",
      "time_spent_seconds": 25
    }
  }
}
```

**Success Response** (201 Created):
```json
{
  "status": "success",
  "message": "Answer recorded successfully",
  "data": {
    "answer": {
      "id": 1,
      "question_id": 1,
      "answer_data": {
        "value": 4,
        "time_spent_seconds": 15
      },
      "created_at": "2026-01-15T10:00:00Z"
    },
    "progress": {
      "answered": 6,
      "total": 24,
      "percentage": 25,
      "remaining": 18
    }
  }
}
```

**Error Response** (422 Unprocessable Entity):
```json
{
  "status": "error",
  "message": "Answer validation failed",
  "errors": {
    "answer_data": ["must contain a 'value' key"],
    "question_id": ["has already been answered"]
  }
}
```

---

#### 3. Skip Question

**Endpoint**: `POST /api/v1/answers/skip`

**Headers**:
```
Authorization: Bearer <jwt_token>
```

**Request Body**:
```json
{
  "question_id": 5
}
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "message": "Question skipped",
  "data": {
    "skips_remaining": 2,
    "progress": {
      "answered": 6,
      "total": 24,
      "percentage": 25,
      "remaining": 18
    }
  }
}
```

**Error Response** (422 Unprocessable Entity):
```json
{
  "status": "error",
  "message": "No skips remaining"
}
```

---

#### 4. Get Onboarding Progress

**Endpoint**: `GET /api/v1/onboarding/progress`

**Headers**:
```
Authorization: Bearer <jwt_token>
```

**Success Response** (200 OK):
```json
{
  "status": "success",
  "data": {
    "progress": {
      "answered": 18,
      "total": 24,
      "percentage": 75,
      "remaining": 6,
      "skipped": 2,
      "skips_remaining": 1
    },
    "by_dimension": [
      {
        "dimension": "liberty_authority",
        "answered": 3,
        "total": 3,
        "complete": true
      },
      {
        "dimension": "economic_equality",
        "answered": 2,
        "total": 3,
        "complete": false
      }
    ],
    "onboarding_complete": false,
    "estimated_time_remaining": "5 minutes"
  }
}
```

---


