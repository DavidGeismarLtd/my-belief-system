# First Principles MVP - Complete Modules Overview

This document provides a comprehensive overview of all 7 MVP modules with technical, product, and UI/UX specifications.

---

## Module 1: Database Foundation & Core Models
**Weeks 1-2 | Backend Lead**

### Technical Specs
**Database Tables** (5):
1. `users` - Authentication and user data
2. `value_dimensions` - 8 core political dimensions (reference data)
3. `questions` - 24 onboarding questions
4. `user_value_portraits` - Calculated user values (position, intensity, confidence)
5. `user_answers` - User responses to questions

**Key Models**:
- User (Devise integration)
- ValueDimension (8 dimensions)
- Question (4 types: direct_value, policy_preference, tradeoff, dilemma)
- UserValuePortrait (position: -1 to +1, intensity: 0-1, confidence: 0-1)
- UserAnswer (JSONB answer_data)

**Seed Data**:
- 8 value dimensions
- 24 questions (3 per dimension)

### Product Specs
**User Stories**:
- As a system, I need a database to store user data
- As a system, I need reference data for value dimensions
- As a system, I need questions to assess user values

**Acceptance Criteria**:
- ✅ All migrations run successfully
- ✅ Seed data loads without errors
- ✅ Models have proper validations
- ✅ Database queries <50ms

### Implementation
**Files to Create**:
```
db/migrate/
  20260115000001_create_users.rb
  20260115000002_create_value_dimensions.rb
  20260115000003_create_questions.rb
  20260115000004_create_user_value_portraits.rb
  20260115000005_create_user_answers.rb
db/seeds/
  value_dimensions.rb
  questions.rb
app/models/
  user.rb
  value_dimension.rb
  question.rb
  user_value_portrait.rb
  user_answer.rb
spec/models/
  user_spec.rb
  value_dimension_spec.rb
  question_spec.rb
  user_value_portrait_spec.rb
  user_answer_spec.rb
```

**Testing**: >90% model coverage, all validations tested

**Detailed Docs**: [M1_DATABASE_FOUNDATION.md](./modules/M1_DATABASE_FOUNDATION.md)

---

## Module 2: Authentication & User Management
**Weeks 3-4 | Backend Lead**

### Technical Specs
**API Endpoints**:
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login (returns JWT)
- `DELETE /api/v1/auth/logout` - User logout
- `GET /api/v1/auth/me` - Get current user
- `POST /api/v1/auth/password/reset` - Request password reset
- `PUT /api/v1/auth/password/reset` - Confirm password reset

**Technologies**:
- Devise for authentication
- JWT for API tokens (24-hour expiration)
- Pundit for authorization
- BCrypt for password hashing

**Security**:
- OWASP Top 10 compliance
- Password requirements: 8+ chars, uppercase, lowercase, number
- Rate limiting on auth endpoints
- HTTPS only in production

### Product Specs
**User Stories**:
- As a user, I want to register with email/password
- As a user, I want to login and stay logged in
- As a user, I want to reset my password if I forget it
- As a user, I want my data to be secure

**Acceptance Criteria**:
- ✅ User can register and receive JWT token
- ✅ User can login with valid credentials
- ✅ Invalid credentials return 401 error
- ✅ Password reset email sent within 1 minute
- ✅ JWT tokens expire after 24 hours
- ✅ Security audit passed

### UI/UX Specs
**Screens** (Frontend - Week 13):
1. Registration form (email, password, name)
2. Login form (email, password)
3. Password reset request form
4. Password reset confirmation form

**Validation**:
- Real-time email format validation
- Password strength indicator
- Clear error messages

**Detailed Docs**: [M2_AUTHENTICATION.md](./modules/M2_AUTHENTICATION.md)

---

## Module 3: Question System & Answer Collection
**Weeks 5-6 | Backend Lead**

### Technical Specs
**API Endpoints**:
- `GET /api/v1/questions` - Get next question(s) for user
- `POST /api/v1/answers` - Submit answer
- `GET /api/v1/onboarding/progress` - Get onboarding progress

**Adaptive Question Logic**:
1. Start with 1 easy question per dimension (8 questions)
2. Based on answers, select 1 medium question per dimension
3. For dimensions with low confidence, add 1 hard question
4. Total: 16-24 questions per user

**Answer Validation**:
- Direct value: 1-5 scale
- Policy preference: Binary choice
- Tradeoff: 0-100 slider
- Dilemma: Choice A or B

### Product Specs
**User Stories**:
- As a user, I want to answer questions about my values
- As a user, I want to see my progress through onboarding
- As a user, I want questions that are relevant to me
- As a user, I want to skip questions I'm unsure about

**Acceptance Criteria**:
- ✅ Questions presented in adaptive order
- ✅ Progress bar updates in real-time
- ✅ Answers validated before submission
- ✅ User can skip up to 3 questions
- ✅ Onboarding takes 15-20 minutes

### UI/UX Specs
**Components**:
1. Question card (text, answer input, skip button)
2. Progress bar (X of Y questions)
3. Answer inputs (scale, binary, slider, choice)
4. Navigation (back, next, skip)

**Interactions**:
- Smooth transitions between questions
- Auto-save answers
- Confirm before skipping
- Celebrate completion

**Detailed Docs**: [M3_QUESTION_SYSTEM.md](./modules/M3_QUESTION_SYSTEM.md)

---

## Module 4: Value Portrait Engine
**Weeks 7-8 | Backend Lead + Data Engineer**

### Technical Specs
**Service**: `ValuePortrait::Builder`

**Algorithm**:
```ruby
# For each dimension:
position = weighted_average(normalized_answers)
intensity = standard_deviation(normalized_answers)
confidence = 1 - (skipped_count / total_questions)
```

**API Endpoints**:
- `POST /api/v1/portraits/generate` - Generate portrait from answers
- `GET /api/v1/portraits` - Get user's portrait
- `PUT /api/v1/portraits/:dimension_id` - Manually adjust dimension

**Performance**: Portrait generation <500ms

### Product Specs
**User Stories**:
- As a user, I want to see my value portrait after onboarding
- As a user, I want to understand what my portrait means
- As a user, I want to adjust my portrait if it's inaccurate
- As a user, I want to see how confident the system is

**Acceptance Criteria**:
- ✅ Portrait generated from 16+ answers
- ✅ All 8 dimensions have values
- ✅ User can manually adjust any dimension
- ✅ 80%+ users say portrait is accurate

### UI/UX Specs
**Visualization**: Radar chart (8 axes)
- Position shown as point on each axis
- Intensity shown as color saturation
- Confidence shown as opacity

**Components**:
1. Radar chart (Recharts)
2. Dimension list (position, intensity, confidence)
3. Manual adjustment sliders
4. Explanation text for each dimension

**Detailed Docs**: [M4_VALUE_PORTRAIT_ENGINE.md](./modules/M4_VALUE_PORTRAIT_ENGINE.md)

---

## Module 5: Political Actor Management
**Weeks 9-10 | Backend Lead + Content Curator**

### Technical Specs
**Database Tables** (2):
1. `political_actors` - Actor metadata
2. `actor_value_portraits` - Actor positions on dimensions

**API Endpoints**:
- `GET /api/v1/actors` - List all actors
- `GET /api/v1/actors/:id` - Get actor details
- `POST /api/v1/actors/:id/track` - Track actor
- `DELETE /api/v1/actors/:id/track` - Untrack actor

**Manual Data Entry**:
- 2 parties: Democratic Party, Republican Party
- 5 personalities: Biden, Trump, Harris, DeSantis, Sanders

### Product Specs
**User Stories**:
- As a user, I want to see available political actors
- As a user, I want to track actors I care about
- As a user, I want to see actor value portraits
- As a user, I want to know how actor data was determined

**Acceptance Criteria**:
- ✅ 7 actors with complete portraits
- ✅ Each actor has 3+ sources cited
- ✅ User can track/untrack actors
- ✅ <5% user-reported data errors

### UI/UX Specs
**Components**:
1. Actor card (name, photo, party, track button)
2. Actor detail page (portrait, bio, sources)
3. Actor list (filterable by party, type)

**Detailed Docs**: [M5_POLITICAL_ACTORS.md](./modules/M5_POLITICAL_ACTORS.md)

---

## Module 6: Alignment Calculation Engine
**Weeks 11-12 | Backend Lead + Data Engineer**

### Technical Specs
**Service**: `Alignment::Calculator`

**Algorithm**:
```ruby
# For each dimension:
dimension_alignment = 1 - abs(user_position - actor_position)
weighted_alignment = dimension_alignment * user_intensity * user_confidence

# Overall:
overall_alignment = sum(weighted_alignments) / sum(weights)
```

**API Endpoints**:
- `GET /api/v1/alignments` - Get all alignments for user
- `GET /api/v1/alignments/:actor_id` - Get alignment with specific actor
- `GET /api/v1/alignments/:actor_id/dimensions` - Dimension breakdown

**Caching**: Redis cache for 24 hours

### Product Specs
**User Stories**:
- As a user, I want to see how aligned I am with each actor
- As a user, I want to understand why I'm aligned/misaligned
- As a user, I want to see dimension-by-dimension breakdown
- As a user, I want explanations in plain language

**Acceptance Criteria**:
- ✅ Alignment calculated for all tracked actors
- ✅ Scores range from 0-100%
- ✅ Explanations generated for each dimension
- ✅ Calculation time <1s per actor

### UI/UX Specs
**Components**:
1. Alignment score (0-100%, color-coded)
2. Dimension breakdown (bar chart)
3. Explanation text
4. Comparison view (user vs actor radar charts)

**Detailed Docs**: [M6_ALIGNMENT_ENGINE.md](./modules/M6_ALIGNMENT_ENGINE.md)

---

## Module 7: User Interface & Dashboard
**Weeks 13-16 | Frontend Lead + Designer**

### Technical Specs
**Tech Stack**:
- React 18+ with TypeScript
- Tailwind CSS for styling
- Recharts for visualizations
- React Router for navigation
- Axios for API calls
- React Query for state management

**Pages**:
1. Landing page
2. Registration/Login
3. Onboarding flow
4. Dashboard
5. Actor detail
6. User profile

### Product Specs
**User Stories**:
- As a user, I want a clean, intuitive interface
- As a user, I want to complete onboarding easily
- As a user, I want to see my alignment at a glance
- As a user, I want to explore actor details

**Acceptance Criteria**:
- ✅ Onboarding completion rate >70%
- ✅ Page load time <3s
- ✅ Mobile responsive
- ✅ WCAG AA accessibility
- ✅ Works on Chrome, Firefox, Safari

### UI/UX Specs
**Design System**:
- Colors: Neutral palette (no partisan colors)
- Typography: Inter font family
- Components: Shadcn UI
- Icons: Heroicons

**Detailed Docs**: [M7_USER_INTERFACE.md](./modules/M7_USER_INTERFACE.md)

---

## Cross-Module Integration Points

1. **Auth → Questions** (Week 6): JWT protects question endpoints
2. **Questions → Portrait** (Week 8): Answers trigger portrait generation
3. **Portrait → Alignment** (Week 12): User portrait compared to actor portraits
4. **All Backend → Frontend** (Week 13-16): API integration

---

## Testing Strategy Summary

| Module | Unit Tests | Integration Tests | E2E Tests |
|--------|-----------|-------------------|-----------|
| M1 | Models (>90%) | N/A | N/A |
| M2 | Controllers, Services | API endpoints | Registration, Login |
| M3 | Services | API endpoints | Onboarding flow |
| M4 | Algorithm | Portrait generation | Portrait creation |
| M5 | Models | Actor API | Actor tracking |
| M6 | Algorithm | Alignment API | Alignment viewing |
| M7 | Components | User flows | Full user journey |

---

**For detailed module specifications, see individual module documents in `/docs/technical/modules/`**

