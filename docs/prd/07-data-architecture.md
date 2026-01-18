# Data Architecture

## Overview

This document defines the data models, database schema, and data flow for First Principles.

## Technology Stack

### Database
- **Primary**: PostgreSQL 15+
- **Rationale**: 
  - JSONB support for flexible value portraits
  - Strong ACID guarantees
  - Excellent full-text search
  - Time-series capabilities for historical tracking

### Caching
- **Redis** for session data and frequently accessed alignments

### Search
- **PostgreSQL full-text search** (MVP)
- **Elasticsearch** (future) for advanced actor search

---

## Core Data Models

### 1. Users

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  encrypted_password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  last_sign_in_at TIMESTAMP,
  
  -- Profile
  country VARCHAR(2), -- ISO country code
  jurisdiction VARCHAR(100), -- e.g., "california", "federal"
  
  -- Preferences
  notification_frequency VARCHAR(20) DEFAULT 'weekly', -- immediate, daily, weekly, off
  notification_threshold DECIMAL(3,2) DEFAULT 0.15, -- minimum change to notify
  
  -- Privacy
  data_sharing_consent BOOLEAN DEFAULT false,
  analytics_consent BOOLEAN DEFAULT true
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_country ON users(country);
```

---

### 2. Value Portraits (User)

```sql
CREATE TABLE user_value_portraits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  version INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  is_current BOOLEAN DEFAULT true,
  
  -- Overall confidence
  confidence_level DECIMAL(3,2) NOT NULL, -- 0.00 to 1.00
  
  -- Dimensions stored as JSONB
  dimensions JSONB NOT NULL,
  
  -- Metadata
  completion_time_seconds INTEGER, -- how long onboarding took
  questions_answered INTEGER,
  questions_skipped INTEGER,
  
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX idx_user_portraits_user ON user_value_portraits(user_id);
CREATE INDEX idx_user_portraits_current ON user_value_portraits(user_id, is_current) WHERE is_current = true;
CREATE INDEX idx_user_portraits_dimensions ON user_value_portraits USING GIN(dimensions);
```

**Dimensions JSONB Structure**:
```json
{
  "liberty_authority": {
    "position": -0.6,
    "intensity": 0.8,
    "confidence": 0.85,
    "last_updated": "2026-01-13T10:30:00Z"
  },
  "economic_equality": {
    "position": -0.4,
    "intensity": 0.7,
    "confidence": 0.80,
    "last_updated": "2026-01-13T10:30:00Z"
  }
  // ... other dimensions
}
```

---

### 3. Value Dimensions (Reference)

```sql
CREATE TABLE value_dimensions (
  id VARCHAR(50) PRIMARY KEY, -- e.g., "liberty_authority"
  name VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  left_pole_label VARCHAR(100) NOT NULL, -- e.g., "Individual Liberty"
  right_pole_label VARCHAR(100) NOT NULL, -- e.g., "Collective Authority"
  left_pole_description TEXT,
  right_pole_description TEXT,
  display_order INTEGER NOT NULL,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO value_dimensions VALUES
  ('liberty_authority', 'Individual Liberty vs Collective Authority', 
   'The balance between personal freedom and state/collective control',
   'Individual Liberty', 'Collective Authority',
   'Minimal government intervention, maximum personal choice',
   'Strong collective governance, regulated behavior for common good',
   1, true, NOW());
-- ... other dimensions
```

---

### 4. Questions

```sql
CREATE TABLE questions (
  id VARCHAR(50) PRIMARY KEY,
  dimension_id VARCHAR(50) NOT NULL REFERENCES value_dimensions(id),
  question_type VARCHAR(20) NOT NULL, -- statement, policy, tradeoff, dilemma
  question_text TEXT NOT NULL,
  
  -- Answer options (JSONB for flexibility)
  answer_options JSONB NOT NULL,
  
  -- Weighting
  weight DECIMAL(3,2) DEFAULT 1.0, -- how much this question matters for the dimension
  
  -- Metadata
  difficulty_level INTEGER DEFAULT 1, -- 1=easy, 5=complex
  requires_context TEXT, -- optional explanation shown before question
  
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_questions_dimension ON questions(dimension_id);
CREATE INDEX idx_questions_active ON questions(active);
```

**Answer Options JSONB Structure**:
```json
{
  "type": "scale", // or "multiple_choice"
  "options": [
    {
      "value": "strongly_disagree",
      "label": "Strongly Disagree",
      "position_impact": -1.0
    },
    {
      "value": "disagree",
      "label": "Disagree",
      "position_impact": -0.5
    },
    {
      "value": "neutral",
      "label": "Neutral",
      "position_impact": 0.0
    }
    // ... more options
  ]
}
```

---

### 5. User Answers

```sql
CREATE TABLE user_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  portrait_id UUID NOT NULL REFERENCES user_value_portraits(id) ON DELETE CASCADE,
  question_id VARCHAR(50) NOT NULL REFERENCES questions(id),
  
  answer_value VARCHAR(50) NOT NULL,
  answered_at TIMESTAMP NOT NULL DEFAULT NOW(),
  
  -- For tracking answer changes
  previous_answer_value VARCHAR(50),
  
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_portrait FOREIGN KEY (portrait_id) REFERENCES user_value_portraits(id),
  CONSTRAINT fk_question FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE INDEX idx_user_answers_user ON user_answers(user_id);
CREATE INDEX idx_user_answers_portrait ON user_answers(portrait_id);
CREATE INDEX idx_user_answers_question ON user_answers(question_id);
```

---

### 6. Political Actors

```sql
CREATE TABLE political_actors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_type VARCHAR(20) NOT NULL, -- party, personality
  
  -- Identity
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL, -- URL-friendly
  
  -- Location
  country VARCHAR(2) NOT NULL,
  jurisdiction VARCHAR(100), -- federal, state name, etc.
  
  -- For personalities
  office VARCHAR(100), -- President, Senator, etc.
  party_affiliation VARCHAR(100),
  
  -- Status
  active BOOLEAN DEFAULT true,
  
  -- Media
  photo_url VARCHAR(500),
  official_website VARCHAR(500),
  
  -- Metadata
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  last_data_update TIMESTAMP
);

CREATE INDEX idx_actors_type ON political_actors(actor_type);
CREATE INDEX idx_actors_country ON political_actors(country);
CREATE INDEX idx_actors_slug ON political_actors(slug);
CREATE INDEX idx_actors_active ON political_actors(active);
CREATE INDEX idx_actors_name_search ON political_actors USING GIN(to_tsvector('english', name));
```

---

### 7. Actor Value Portraits

```sql
CREATE TABLE actor_value_portraits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id UUID NOT NULL REFERENCES political_actors(id) ON DELETE CASCADE,
  version INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  is_current BOOLEAN DEFAULT true,
  
  -- Overall confidence
  confidence_level DECIMAL(3,2) NOT NULL,
  
  -- Dimensions (same structure as user portraits)
  dimensions JSONB NOT NULL,
  
  -- Metadata
  sources_count INTEGER DEFAULT 0,
  last_source_date TIMESTAMP,
  
  CONSTRAINT fk_actor FOREIGN KEY (actor_id) REFERENCES political_actors(id)
);

CREATE INDEX idx_actor_portraits_actor ON actor_value_portraits(actor_id);
CREATE INDEX idx_actor_portraits_current ON actor_value_portraits(actor_id, is_current) WHERE is_current = true;
CREATE INDEX idx_actor_portraits_dimensions ON actor_value_portraits USING GIN(dimensions);
```

---

### 8. Sources

```sql
CREATE TABLE sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id UUID NOT NULL REFERENCES political_actors(id) ON DELETE CASCADE,
  
  -- Source metadata
  source_type VARCHAR(20) NOT NULL, -- vote, speech, platform, statement, social_media
  tier INTEGER NOT NULL, -- 1-4, based on commitment level
  
  -- Content
  title VARCHAR(500) NOT NULL,
  content TEXT,
  url VARCHAR(1000),
  
  -- Dates
  published_at TIMESTAMP NOT NULL,
  collected_at TIMESTAMP NOT NULL DEFAULT NOW(),
  
  -- Processing
  processed BOOLEAN DEFAULT false,
  processed_at TIMESTAMP,
  processing_error TEXT,
  
  CONSTRAINT fk_actor FOREIGN KEY (actor_id) REFERENCES political_actors(id)
);

CREATE INDEX idx_sources_actor ON sources(actor_id);
CREATE INDEX idx_sources_type ON sources(source_type);
CREATE INDEX idx_sources_published ON sources(published_at DESC);
CREATE INDEX idx_sources_processed ON sources(processed);
CREATE INDEX idx_sources_content_search ON sources USING GIN(to_tsvector('english', content));
```

---

### 9. Positions (Extracted from Sources)

```sql
CREATE TABLE positions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id UUID NOT NULL REFERENCES political_actors(id) ON DELETE CASCADE,
  source_id UUID NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  dimension_id VARCHAR(50) NOT NULL REFERENCES value_dimensions(id),
  
  -- Position data
  position DECIMAL(4,2) NOT NULL, -- -1.00 to +1.00
  intensity DECIMAL(3,2) NOT NULL, -- 0.00 to 1.00
  confidence DECIMAL(3,2) NOT NULL, -- 0.00 to 1.00
  weight DECIMAL(3,2) NOT NULL, -- final weight (tier * confidence)
  
  -- Extraction metadata
  extracted_at TIMESTAMP NOT NULL DEFAULT NOW(),
  extraction_method VARCHAR(50), -- manual, nlp_v1, etc.
  
  CONSTRAINT fk_actor FOREIGN KEY (actor_id) REFERENCES political_actors(id),
  CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES sources(id),
  CONSTRAINT fk_dimension FOREIGN KEY (dimension_id) REFERENCES value_dimensions(id)
);

CREATE INDEX idx_positions_actor ON positions(actor_id);
CREATE INDEX idx_positions_source ON positions(source_id);
CREATE INDEX idx_positions_dimension ON positions(dimension_id);
CREATE INDEX idx_positions_extracted ON positions(extracted_at DESC);
```

---

### 10. Alignments (Calculated)

```sql
CREATE TABLE alignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  actor_id UUID NOT NULL REFERENCES political_actors(id) ON DELETE CASCADE,
  
  -- Scores
  overall_score DECIMAL(3,2) NOT NULL, -- 0.00 to 1.00
  overall_confidence DECIMAL(3,2) NOT NULL,
  
  -- Dimension-level scores (JSONB)
  dimension_scores JSONB NOT NULL,
  
  -- Calculation metadata
  calculated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  user_portrait_version INTEGER NOT NULL,
  actor_portrait_version INTEGER NOT NULL,
  
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_actor FOREIGN KEY (actor_id) REFERENCES political_actors(id),
  UNIQUE(user_id, actor_id, calculated_at)
);

CREATE INDEX idx_alignments_user ON alignments(user_id);
CREATE INDEX idx_alignments_actor ON alignments(actor_id);
CREATE INDEX idx_alignments_calculated ON alignments(calculated_at DESC);
CREATE INDEX idx_alignments_user_actor ON alignments(user_id, actor_id, calculated_at DESC);
```

**Dimension Scores JSONB Structure**:
```json
{
  "liberty_authority": {
    "user_position": -0.6,
    "actor_position": -0.4,
    "alignment_score": 0.9,
    "weighted_score": 0.72,
    "confidence": 0.85
  }
  // ... other dimensions
}
```

---

### 11. User Tracking (Which actors user follows)

```sql
CREATE TABLE user_actor_tracking (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  actor_id UUID NOT NULL REFERENCES political_actors(id) ON DELETE CASCADE,
  
  started_tracking_at TIMESTAMP NOT NULL DEFAULT NOW(),
  stopped_tracking_at TIMESTAMP,
  is_active BOOLEAN DEFAULT true,
  
  -- Notification preferences for this specific actor
  notify_on_change BOOLEAN DEFAULT true,
  
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_actor FOREIGN KEY (actor_id) REFERENCES political_actors(id),
  UNIQUE(user_id, actor_id)
);

CREATE INDEX idx_tracking_user ON user_actor_tracking(user_id);
CREATE INDEX idx_tracking_actor ON user_actor_tracking(actor_id);
CREATE INDEX idx_tracking_active ON user_actor_tracking(user_id, is_active) WHERE is_active = true;
```

---

**Next**: [08-technical-architecture.md](./08-technical-architecture.md) - System design and infrastructure

