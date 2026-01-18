# Technical Architecture

## System Overview

First Principles is a web application with the following high-level architecture:

```
┌─────────────┐
│   Browser   │
│  (React/TS) │
└──────┬──────┘
       │ HTTPS
       ▼
┌─────────────┐
│   Rails API │
│  (Backend)  │
└──────┬──────┘
       │
       ├──────► PostgreSQL (Primary Data)
       ├──────► Redis (Cache/Sessions)
       ├──────► Background Jobs (Sidekiq)
       └──────► External APIs (Data Collection)
```

---

## Technology Stack

### Frontend
- **Framework**: React 18+ with TypeScript
- **Build Tool**: Vite or esbuild
- **State Management**: React Query + Context API
- **Routing**: React Router v6
- **UI Components**: Headless UI + Tailwind CSS
- **Charts**: Recharts or D3.js
- **Forms**: React Hook Form + Zod validation

### Backend
- **Framework**: Ruby on Rails 8.1+ (already in use)
- **API**: RESTful JSON API (Rails API mode)
- **Authentication**: Devise + JWT
- **Authorization**: Pundit
- **Background Jobs**: Sidekiq
- **Testing**: RSpec

### Database & Storage
- **Primary DB**: PostgreSQL 15+
- **Cache**: Redis 7+
- **File Storage**: AWS S3 (for actor photos, exports)
- **Search**: PostgreSQL full-text (MVP), Elasticsearch (future)

### Infrastructure
- **Hosting**: AWS or Heroku (MVP)
- **CDN**: CloudFront or Cloudflare
- **Monitoring**: Sentry (errors), DataDog (metrics)
- **CI/CD**: GitHub Actions

### External Services
- **Email**: SendGrid or AWS SES
- **Data Sources**: 
  - ProPublica Congress API
  - GovTrack API
  - Custom scrapers for party platforms

---

## Application Architecture

### Backend Structure (Rails)

```
app/
├── controllers/
│   ├── api/
│   │   ├── v1/
│   │   │   ├── users_controller.rb
│   │   │   ├── value_portraits_controller.rb
│   │   │   ├── questions_controller.rb
│   │   │   ├── actors_controller.rb
│   │   │   ├── alignments_controller.rb
│   │   │   └── tracking_controller.rb
│   │   └── base_controller.rb
│   └── application_controller.rb
│
├── models/
│   ├── user.rb
│   ├── user_value_portrait.rb
│   ├── value_dimension.rb
│   ├── question.rb
│   ├── user_answer.rb
│   ├── political_actor.rb
│   ├── actor_value_portrait.rb
│   ├── source.rb
│   ├── position.rb
│   ├── alignment.rb
│   └── user_actor_tracking.rb
│
├── services/
│   ├── value_portrait/
│   │   ├── builder.rb          # Build user portrait from answers
│   │   ├── calculator.rb       # Calculate dimension positions
│   │   └── confidence_scorer.rb
│   ├── actor_monitoring/
│   │   ├── source_collector.rb # Collect data from APIs
│   │   ├── content_analyzer.rb # NLP to extract positions
│   │   └── portrait_updater.rb # Update actor portraits
│   ├── alignment/
│   │   ├── calculator.rb       # Calculate alignment scores
│   │   ├── change_detector.rb  # Detect significant changes
│   │   └── explainer.rb        # Generate explanations
│   └── notifications/
│       └── change_notifier.rb  # Send change notifications
│
├── jobs/
│   ├── collect_sources_job.rb
│   ├── analyze_source_job.rb
│   ├── update_actor_portrait_job.rb
│   ├── calculate_alignments_job.rb
│   └── send_notifications_job.rb
│
└── serializers/
    ├── user_value_portrait_serializer.rb
    ├── actor_serializer.rb
    ├── alignment_serializer.rb
    └── ...
```

---

## Key Services & Algorithms

### 1. Value Portrait Builder

**Purpose**: Convert user answers into value portrait

**Input**: Array of `UserAnswer` objects

**Output**: `UserValuePortrait` with calculated positions

**Algorithm**:
```ruby
class ValuePortrait::Builder
  def build(user_answers)
    dimensions = {}
    
    VALUE_DIMENSIONS.each do |dimension_id|
      # Get all answers for this dimension
      relevant_answers = user_answers.select { |a| a.question.dimension_id == dimension_id }
      
      # Calculate weighted position
      position = calculate_position(relevant_answers)
      intensity = calculate_intensity(relevant_answers)
      confidence = calculate_confidence(relevant_answers)
      
      dimensions[dimension_id] = {
        position: position,
        intensity: intensity,
        confidence: confidence
      }
    end
    
    UserValuePortrait.create!(
      user_id: user.id,
      dimensions: dimensions,
      confidence_level: overall_confidence(dimensions)
    )
  end
  
  private
  
  def calculate_position(answers)
    # Weighted average of answer impacts
    total_weight = 0
    weighted_sum = 0
    
    answers.each do |answer|
      impact = answer.question.answer_options['options']
        .find { |o| o['value'] == answer.answer_value }['position_impact']
      weight = answer.question.weight
      
      weighted_sum += impact * weight
      total_weight += weight
    end
    
    weighted_sum / total_weight
  end
  
  def calculate_intensity(answers)
    # Based on how strongly user answered (strongly agree vs agree)
    # Returns 0.0 to 1.0
  end
  
  def calculate_confidence(answers)
    # Based on consistency and coverage
    # Returns 0.0 to 1.0
  end
end
```

---

### 2. Content Analyzer (NLP)

**Purpose**: Extract political positions from text

**Input**: Source text (speech, statement, etc.)

**Output**: Array of `Position` objects

**Approach** (MVP - Rule-based):
```ruby
class ActorMonitoring::ContentAnalyzer
  KEYWORDS = {
    'liberty_authority' => {
      liberty: ['freedom', 'liberty', 'individual rights', 'deregulation'],
      authority: ['regulation', 'government control', 'collective good']
    },
    # ... other dimensions
  }
  
  def analyze(source)
    positions = []
    
    VALUE_DIMENSIONS.each do |dimension_id|
      position = extract_position(source.content, dimension_id)
      
      if position
        positions << Position.create!(
          actor_id: source.actor_id,
          source_id: source.id,
          dimension_id: dimension_id,
          position: position[:value],
          intensity: position[:intensity],
          confidence: position[:confidence],
          weight: source.tier * position[:confidence]
        )
      end
    end
    
    positions
  end
  
  private
  
  def extract_position(text, dimension_id)
    # Keyword matching, sentiment analysis, etc.
    # Returns { value: -1.0 to 1.0, intensity: 0-1, confidence: 0-1 }
  end
end
```

**Future Enhancement**: Use LLM (GPT-4, Claude) for more sophisticated analysis

---

### 3. Alignment Calculator

**Purpose**: Calculate alignment between user and actor

**Input**: `UserValuePortrait`, `ActorValuePortrait`

**Output**: `Alignment` object

**Algorithm**:
```ruby
class Alignment::Calculator
  def calculate(user_portrait, actor_portrait)
    dimension_scores = {}
    total_weighted_alignment = 0
    total_intensity = 0
    
    user_portrait.dimensions.each do |dimension_id, user_dim|
      actor_dim = actor_portrait.dimensions[dimension_id]
      
      # Calculate raw alignment (0 to 1)
      raw_alignment = 1 - ((user_dim['position'] - actor_dim['position']).abs / 2.0)
      
      # Weight by user intensity and confidence
      confidence = [user_dim['confidence'], actor_dim['confidence']].min
      weighted_alignment = raw_alignment * user_dim['intensity'] * confidence
      
      dimension_scores[dimension_id] = {
        user_position: user_dim['position'],
        actor_position: actor_dim['position'],
        alignment_score: raw_alignment,
        weighted_score: weighted_alignment,
        confidence: confidence
      }
      
      total_weighted_alignment += weighted_alignment
      total_intensity += user_dim['intensity']
    end
    
    overall_score = total_weighted_alignment / total_intensity
    
    Alignment.create!(
      user_id: user_portrait.user_id,
      actor_id: actor_portrait.actor_id,
      overall_score: overall_score,
      overall_confidence: calculate_overall_confidence(dimension_scores),
      dimension_scores: dimension_scores,
      user_portrait_version: user_portrait.version,
      actor_portrait_version: actor_portrait.version
    )
  end
end
```

---

### 4. Change Detector

**Purpose**: Identify significant changes in alignment

**Input**: Current and historical `Alignment` records

**Output**: Array of change events

**Algorithm**:
```ruby
class Alignment::ChangeDetector
  THRESHOLDS = {
    significant: 0.15,  # 30-day change
    major: 0.25         # 90-day change
  }
  
  def detect_changes(user_id, actor_id)
    current = Alignment.current(user_id, actor_id)
    past_30d = Alignment.at_date(user_id, actor_id, 30.days.ago)
    past_90d = Alignment.at_date(user_id, actor_id, 90.days.ago)
    
    changes = []
    
    # Check overall alignment change
    if (current.overall_score - past_30d.overall_score).abs > THRESHOLDS[:significant]
      changes << {
        type: 'overall_change',
        magnitude: current.overall_score - past_30d.overall_score,
        timeframe: '30_days'
      }
    end
    
    # Check dimension-level changes
    current.dimension_scores.each do |dimension_id, scores|
      past_scores = past_30d.dimension_scores[dimension_id]
      change = scores['alignment_score'] - past_scores['alignment_score']
      
      if change.abs > THRESHOLDS[:significant]
        changes << {
          type: 'dimension_change',
          dimension_id: dimension_id,
          magnitude: change,
          timeframe: '30_days',
          trigger_source: find_trigger_source(actor_id, dimension_id, 30.days.ago)
        }
      end
    end
    
    changes
  end
end
```

---

## Background Jobs

### Job Schedule

**Hourly**:
- `CollectSourcesJob` - Fetch new data from APIs

**Every 6 hours**:
- `AnalyzeSourceJob` - Process collected sources with NLP
- `UpdateActorPortraitJob` - Recalculate actor portraits

**Daily**:
- `CalculateAlignmentsJob` - Recalculate all active alignments
- `SendNotificationsJob` - Send daily digest emails

**Weekly**:
- `CleanupOldDataJob` - Archive old alignment records

---

## API Design

### RESTful Endpoints

**Authentication**:
```
POST   /api/v1/auth/signup
POST   /api/v1/auth/login
POST   /api/v1/auth/logout
GET    /api/v1/auth/me
```

**Value Portraits**:
```
GET    /api/v1/value_portraits/current
POST   /api/v1/value_portraits
PATCH  /api/v1/value_portraits/:id
GET    /api/v1/value_portraits/:id/history
```

**Questions**:
```
GET    /api/v1/questions              # Get onboarding questions
GET    /api/v1/questions/:dimension   # Get questions for specific dimension
```

**Answers**:
```
POST   /api/v1/answers                # Submit answer
PATCH  /api/v1/answers/:id            # Update answer
```

**Actors**:
```
GET    /api/v1/actors                 # List/search actors
GET    /api/v1/actors/:id             # Get actor details
GET    /api/v1/actors/:id/portrait    # Get actor value portrait
GET    /api/v1/actors/:id/timeline    # Get historical positions
GET    /api/v1/actors/:id/sources     # Get sources for actor
```

**Alignments**:
```
GET    /api/v1/alignments             # Get all user's alignments
GET    /api/v1/alignments/:actor_id   # Get alignment with specific actor
GET    /api/v1/alignments/:actor_id/history  # Historical alignment
```

**Tracking**:
```
GET    /api/v1/tracking               # Get tracked actors
POST   /api/v1/tracking/:actor_id     # Start tracking
DELETE /api/v1/tracking/:actor_id     # Stop tracking
```

---

## Security

### Authentication
- JWT tokens with 24-hour expiration
- Refresh tokens stored in httpOnly cookies
- Password requirements: min 12 chars, complexity rules

### Authorization
- User can only access their own data
- Admin role for content management
- Rate limiting on all endpoints

### Data Protection
- Encryption at rest for sensitive data
- HTTPS only
- CORS configured for frontend domain only
- SQL injection prevention (parameterized queries)
- XSS prevention (sanitized outputs)

---

## Performance Optimization

### Caching Strategy
- User portraits: Cache for 1 hour
- Actor portraits: Cache for 6 hours
- Alignments: Cache for 1 hour
- Static data (dimensions, questions): Cache indefinitely

### Database Optimization
- Indexes on all foreign keys
- GIN indexes for JSONB columns
- Partial indexes for active records
- Query optimization with EXPLAIN ANALYZE

### Frontend Optimization
- Code splitting by route
- Lazy loading of charts
- Image optimization (WebP, lazy loading)
- Service worker for offline support

---

**Next**: [09-implementation-roadmap.md](./09-implementation-roadmap.md) - Phased delivery plan

