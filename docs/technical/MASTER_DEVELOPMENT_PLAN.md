# First Principles MVP - Master Development Plan

## Document Overview

This document provides a comprehensive development plan for the First Principles MVP, covering the complete 4-month implementation timeline with detailed module breakdown, dependencies, resource allocation, and risk management.

**Timeline**: Months 1-4 (16 weeks)
**Target**: 100 users, 60% Day 7 retention, 4.0+ CSAT
**Scope**: Core value portrait system + manual actor tracking + basic alignment

---

## Executive Summary

### MVP Modules (7 Core Modules)

1. **Module 1: Database Foundation & Core Models** (Weeks 1-2)
2. **Module 2: Authentication & User Management** (Weeks 3-4)
3. **Module 3: Question System & Answer Collection** (Weeks 5-6)
4. **Module 4: Value Portrait Engine** (Weeks 7-8)
5. **Module 5: Political Actor Management** (Weeks 9-10)
6. **Module 6: Alignment Calculation Engine** (Weeks 11-12)
7. **Module 7: User Interface & Dashboard** (Weeks 13-16)

### Critical Path
```
Database → Auth → Questions → Portrait Engine → Actors → Alignment → UI
```

All modules are sequential dependencies except UI components which can be developed in parallel starting Week 9.

---

## Module Dependency Matrix

| Module | Depends On | Blocks | Can Parallel With |
|--------|-----------|--------|-------------------|
| M1: Database | None | All | None |
| M2: Auth | M1 | M3, M4, M7 | None |
| M3: Questions | M1, M2 | M4 | None |
| M4: Portrait Engine | M1, M2, M3 | M6, M7 | M5 |
| M5: Actors | M1 | M6 | M4 |
| M6: Alignment | M1, M4, M5 | M7 | UI prototyping |
| M7: UI/Dashboard | M2, M4, M6 | Launch | None |

---

## Detailed Timeline

### Month 1: Foundation (Weeks 1-4)

#### Week 1-2: Module 1 - Database Foundation
**Owner**: Backend Lead
**Team**: 1 Backend Engineer

**Deliverables**:
- [ ] PostgreSQL database setup
- [ ] 5 core table migrations (users, value_dimensions, questions, user_value_portraits, user_answers)
- [ ] Database indexes and constraints
- [ ] Seed data: 8 value dimensions
- [ ] Seed data: 24 questions (3 per dimension)
- [ ] ActiveRecord models with validations
- [ ] Model unit tests (>90% coverage)

**Exit Criteria**:
- All migrations run successfully
- Seed data loads without errors
- All model tests passing
- Database performance benchmarks met (<50ms queries)

---

#### Week 3-4: Module 2 - Authentication & User Management
**Owner**: Backend Lead
**Team**: 1 Backend Engineer

**Deliverables**:
- [ ] Devise integration for user authentication
- [ ] JWT token generation and validation
- [ ] User registration API endpoint
- [ ] User login/logout API endpoints
- [ ] Password reset flow
- [ ] User profile API endpoints
- [ ] Pundit authorization setup
- [ ] Auth integration tests

**Exit Criteria**:
- Users can register, login, logout
- JWT tokens work correctly
- Password reset emails sent
- All auth tests passing
- Security audit passed (OWASP top 10)

---

### Month 2: Value Portrait System (Weeks 5-8)

#### Week 5-6: Module 3 - Question System & Answer Collection
**Owner**: Backend Lead
**Team**: 1 Backend Engineer

**Deliverables**:
- [ ] Questions API endpoint (GET /api/v1/questions)
- [ ] Adaptive question selection algorithm
- [ ] User answers API endpoint (POST /api/v1/answers)
- [ ] Answer validation and storage
- [ ] Progress tracking logic
- [ ] Question service layer
- [ ] Answer service layer
- [ ] Service and controller tests

**Exit Criteria**:
- API returns questions in correct order
- Answers are validated and stored
- Progress tracking works
- All tests passing
- API response time <200ms

---

#### Week 7-8: Module 4 - Value Portrait Engine
**Owner**: Backend Lead + Data Engineer
**Team**: 1 Backend Engineer, 1 Data Engineer

**Deliverables**:
- [ ] ValuePortrait::Builder service
- [ ] Position calculation algorithm
- [ ] Intensity calculation algorithm
- [ ] Confidence calculation algorithm
- [ ] Portrait generation API endpoint
- [ ] Portrait retrieval API endpoint
- [ ] Portrait update/refinement logic
- [ ] Algorithm validation tests
- [ ] Edge case handling

**Exit Criteria**:
- Portrait generated from 24 answers
- Position values accurate (-1 to +1)
- Confidence scores meaningful
- Algorithm tests passing (>95% coverage)
- Portrait generation <500ms

---

### Month 3: Political Actors & Alignment (Weeks 9-12)

#### Week 9-10: Module 5 - Political Actor Management
**Owner**: Backend Lead + Content Lead
**Team**: 1 Backend Engineer, 1 Content Curator

**Deliverables**:
- [ ] Political actors table migration
- [ ] Actor value portraits table migration
- [ ] Admin interface for actor data entry
- [ ] Actor CRUD API endpoints
- [ ] Actor portrait storage
- [ ] Manual data entry: 2 parties (Dem, Rep)
- [ ] Manual data entry: 5 personalities
- [ ] Actor API tests

**Exit Criteria**:
- 7 actors in database with portraits
- Admin can add/edit actors
- Actor API working
- All tests passing
- Data quality validated

---

#### Week 11-12: Module 6 - Alignment Calculation Engine
**Owner**: Backend Lead + Data Engineer
**Team**: 1 Backend Engineer, 1 Data Engineer

**Deliverables**:
- [ ] Alignments table migration
- [ ] Alignment::Calculator service
- [ ] Dimension-level alignment calculation
- [ ] Weighted alignment calculation
- [ ] Overall alignment score calculation
- [ ] Alignment explanation generator
- [ ] Alignment API endpoints
- [ ] Alignment caching strategy
- [ ] Algorithm tests

**Exit Criteria**:
- Alignment calculated for user-actor pairs
- Scores accurate (0-1 range)
- Explanations generated
- Calculation time <1s
- All tests passing (>95% coverage)

---

### Month 4: User Interface & Launch (Weeks 13-16)

#### Week 13-14: Module 7A - Onboarding UI
**Owner**: Frontend Lead
**Team**: 1 Frontend Engineer, 1 Designer

**Deliverables**:
- [ ] React app setup with TypeScript
- [ ] Tailwind CSS configuration
- [ ] Onboarding flow components
- [ ] Question display component
- [ ] Progress indicator component
- [ ] Answer input components
- [ ] Portrait visualization (radar chart)
- [ ] Portrait review screen
- [ ] Responsive design (mobile/desktop)
- [ ] Frontend tests

**Exit Criteria**:
- Complete onboarding flow works
- Radar chart displays correctly
- Mobile responsive
- Accessibility audit passed (WCAG AA)
- All frontend tests passing

---

#### Week 15: Module 7B - Dashboard & Actor Views
**Owner**: Frontend Lead
**Team**: 1 Frontend Engineer, 1 Designer

**Deliverables**:
- [ ] Dashboard layout
- [ ] Actor card components
- [ ] Alignment display components
- [ ] Actor detail page
- [ ] Dimension breakdown view
- [ ] Actor tracking (follow/unfollow)
- [ ] Filtering and sorting
- [ ] Loading states and error handling

**Exit Criteria**:
- Dashboard displays all tracked actors
- Actor details accessible
- Alignment scores visible
- All interactions working
- Performance targets met (<3s load)

---

#### Week 16: Integration, Testing & Launch
**Owner**: Product Manager
**Team**: Full team

**Deliverables**:
- [ ] End-to-end testing
- [ ] Performance optimization
- [ ] Security audit
- [ ] Bug fixes
- [ ] Heroku deployment
- [ ] Monitoring setup (Sentry)
- [ ] Analytics setup
- [ ] Beta testing (20 users)
- [ ] Launch to 100 users

**Exit Criteria**:
- All E2E tests passing
- Performance targets met
- Security audit passed
- 99%+ uptime
- Beta feedback incorporated
- 100 users onboarded

---

## Resource Allocation

### Team Structure (MVP)

**Core Team** (4 people):
- 1 Product Manager (full-time)
- 1 Backend Engineer (full-time)
- 1 Frontend Engineer (full-time)
- 1 Designer (part-time, 50%)

**Supporting Team** (2 people):
- 1 Data Engineer (part-time, 50%, Weeks 7-12)
- 1 Content Curator (part-time, 25%, Weeks 9-10)

### Weekly Effort Distribution

| Week | Backend | Frontend | Design | Data | Content | PM |
|------|---------|----------|--------|------|---------|-----|
| 1-2  | 40h | 0h | 0h | 0h | 0h | 20h |
| 3-4  | 40h | 0h | 0h | 0h | 0h | 20h |
| 5-6  | 40h | 0h | 0h | 0h | 0h | 20h |
| 7-8  | 30h | 0h | 0h | 20h | 0h | 20h |
| 9-10 | 30h | 0h | 10h | 0h | 10h | 20h |
| 11-12| 30h | 0h | 0h | 20h | 0h | 20h |
| 13-14| 10h | 40h | 20h | 0h | 0h | 20h |
| 15   | 10h | 40h | 20h | 0h | 0h | 20h |
| 16   | 20h | 20h | 10h | 0h | 0h | 40h |

**Total Effort**: ~1,000 hours over 16 weeks

---

## Risk Assessment & Mitigation

### High-Risk Items

#### Risk 1: Value Portrait Algorithm Accuracy
**Probability**: Medium
**Impact**: High
**Description**: Portrait calculation may not accurately reflect user values

**Mitigation**:
- Validate algorithm with 50+ test users before Week 8
- A/B test different calculation approaches
- Allow manual portrait adjustment
- Collect user feedback on accuracy

**Contingency**: Simplify algorithm, increase manual adjustment options

---

#### Risk 2: Manual Actor Data Quality
**Probability**: Medium
**Impact**: Medium
**Description**: Manually entered actor data may be biased or inaccurate

**Mitigation**:
- Use multiple sources for each actor
- Have 2 people independently research each actor
- Document all sources
- User feedback mechanism for data corrections

**Contingency**: Reduce actor count to 4-5 highest quality profiles

---

#### Risk 3: Frontend Performance
**Probability**: Low
**Impact**: Medium
**Description**: Radar charts and complex UI may be slow

**Mitigation**:
- Performance testing from Week 13
- Use React.memo and useMemo
- Lazy load components
- Optimize bundle size

**Contingency**: Simplify visualizations, use static images for MVP

---

#### Risk 4: Timeline Slippage
**Probability**: High
**Impact**: High
**Description**: Development may take longer than 16 weeks

**Mitigation**:
- Weekly progress reviews
- 20% time buffer built into each module
- Prioritize ruthlessly (MVP only)
- Daily standups to catch blockers early

**Contingency**:
- Cut scope: Reduce to 4 actors, 16 questions
- Extend timeline by 2 weeks
- Bring in contractor for specific modules

---

#### Risk 5: User Adoption
**Probability**: Medium
**Impact**: High
**Description**: May not reach 100 users or retention targets

**Mitigation**:
- Start user recruitment in Week 12
- Beta program with incentives
- User feedback loops throughout
- Marketing prep during development

**Contingency**: Lower targets to 50 users, 50% retention for MVP validation

---

### Medium-Risk Items

#### Risk 6: Third-Party Dependencies
**Probability**: Low
**Impact**: Medium
**Description**: Devise, React libraries may have issues

**Mitigation**: Use well-established, maintained libraries only
**Contingency**: Have alternative libraries identified

#### Risk 7: Database Performance
**Probability**: Low
**Impact**: Medium
**Description**: JSONB queries may be slow at scale

**Mitigation**: Index optimization, query profiling from Week 1
**Contingency**: Denormalize data if needed

---

## Integration Points

### Module Integration Map

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend (React)                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │Onboarding│  │Dashboard │  │  Actor   │             │
│  │   Flow   │  │          │  │ Details  │             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼─────────────┼────────────────────┘
        │             │             │
        │ API Calls   │ API Calls   │ API Calls
        ▼             ▼             ▼
┌─────────────────────────────────────────────────────────┐
│                   Rails API Layer                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │Questions │  │Alignment │  │  Actors  │             │
│  │Controller│  │Controller│  │Controller│             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼─────────────┼────────────────────┘
        │             │             │
        ▼             ▼             ▼
┌─────────────────────────────────────────────────────────┐
│                   Service Layer                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │Portrait  │  │Alignment │  │  Actor   │             │
│  │ Builder  │  │Calculator│  │ Manager  │             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼─────────────┼────────────────────┘
        │             │             │
        └─────────────┴─────────────┘
                      │
                      ▼
              ┌──────────────┐
              │  PostgreSQL  │
              └──────────────┘
```

### Critical Integration Points

**IP-1: Frontend ↔ Auth API** (Week 4)
- JWT token handling
- Protected route implementation
- Session management

**IP-2: Questions API ↔ Portrait Builder** (Week 8)
- Answer collection → Portrait generation
- Real-time progress updates
- Portrait retrieval

**IP-3: Portrait Engine ↔ Alignment Engine** (Week 12)
- User portrait → Alignment calculation
- Actor portrait → Alignment calculation
- Score caching

**IP-4: Alignment API ↔ Dashboard UI** (Week 15)
- Alignment data display
- Real-time updates
- Filtering and sorting

---

## Testing Strategy

### Unit Testing

**Coverage Target**: >90% for all modules

**Tools**: RSpec (backend), Jest (frontend)

**Approach**:
- Test-driven development for algorithms (Portrait, Alignment)
- Model validations tested
- Service layer fully tested
- Component testing for React

**Schedule**: Continuous, tests written alongside code

---

### Integration Testing

**Coverage Target**: All API endpoints, all user flows

**Tools**: RSpec request specs, React Testing Library

**Approach**:
- API endpoint integration tests
- Database transaction tests
- Service integration tests
- Component integration tests

**Schedule**:
- API tests: Weeks 3-12
- Frontend integration: Weeks 13-15

---

### End-to-End Testing

**Coverage Target**: 5 critical user flows

**Tools**: Cypress

**Critical Flows**:
1. User registration → Onboarding → Portrait creation
2. Login → View dashboard → View actor details
3. Login → View alignment → Explore dimensions
4. Login → Refine portrait → See updated alignment
5. Login → Track actor → Untrack actor

**Schedule**: Week 16

---

### Performance Testing

**Targets**:
- API response time: <200ms (p95)
- Page load time: <3s (p95)
- Portrait calculation: <500ms
- Alignment calculation: <1s

**Tools**:
- Backend: rack-mini-profiler, bullet
- Frontend: Lighthouse, WebPageTest

**Schedule**:
- Backend: Continuous profiling from Week 1
- Frontend: Week 14-15

---

### Security Testing

**Requirements**:
- OWASP Top 10 compliance
- SQL injection prevention
- XSS prevention
- CSRF protection
- Authentication security

**Tools**: Brakeman, bundler-audit

**Schedule**:
- Automated scans: Weekly from Week 3
- Manual audit: Week 16

---

### User Acceptance Testing

**Participants**: 20 beta users

**Scenarios**:
- Complete onboarding (all 20 users)
- Explore dashboard (all 20 users)
- Provide feedback (all 20 users)

**Success Criteria**:
- 80% complete onboarding
- 4.0+ CSAT
- <5 critical bugs found

**Schedule**: Week 16 (days 1-5)

---

## Deployment Strategy

### Infrastructure

**Platform**: Heroku (MVP)

**Services**:
- Web dyno: Standard-1X (2 dynos for redundancy)
- Database: Heroku Postgres Standard-0
- Redis: Heroku Redis Premium-0
- Monitoring: Sentry (error tracking)

**Cost Estimate**: ~$100/month

---

### Deployment Pipeline

**Environments**:
1. **Development**: Local machines
2. **Staging**: Heroku staging app
3. **Production**: Heroku production app

**CI/CD**: GitHub Actions

**Pipeline**:
```
Code Push → GitHub Actions → Run Tests → Deploy to Staging → Manual Approval → Deploy to Production
```

---

### Deployment Schedule

**Week 12**: Staging environment setup
**Week 14**: First staging deployment
**Week 15**: Staging testing and fixes
**Week 16 Day 1**: Production deployment
**Week 16 Day 2-5**: Beta testing
**Week 16 Day 6**: Public launch (100 users)

---

## Monitoring & Observability

### Error Tracking
- **Tool**: Sentry
- **Setup**: Week 16
- **Alerts**: Slack notifications for errors

### Performance Monitoring
- **Tool**: Heroku metrics + custom dashboards
- **Metrics**: Response time, throughput, error rate
- **Setup**: Week 16

### User Analytics
- **Tool**: Custom analytics (privacy-focused)
- **Metrics**: Onboarding completion, retention, engagement
- **Setup**: Week 16

### Uptime Monitoring
- **Tool**: Heroku status + UptimeRobot
- **Target**: 99%+ uptime
- **Setup**: Week 16

---

## Success Criteria

### Technical Success

- [ ] All 7 modules completed on time
- [ ] >90% test coverage
- [ ] All integration points working
- [ ] Performance targets met
- [ ] Security audit passed
- [ ] 99%+ uptime in first month

### Product Success

- [ ] 100 users complete onboarding
- [ ] 60% Day 7 retention
- [ ] 4.0+ CSAT score
- [ ] 70%+ say "helped me understand my values"
- [ ] <5% user-reported data errors

### Business Success

- [ ] MVP launched on time (Week 16)
- [ ] Within budget (~$10k for 4 months)
- [ ] Validated product-market fit
- [ ] Ready for V1.0 development

---

## Next Steps

1. **Review this plan** with full team
2. **Assign module owners** (Week 0)
3. **Set up development environment** (Week 0)
4. **Begin Module 1** (Week 1)
5. **Weekly progress reviews** (Every Friday)

---

## Appendix: Module Documents

Detailed specifications for each module:

1. [Module 1: Database Foundation](./modules/M1_DATABASE_FOUNDATION.md)
2. [Module 2: Authentication](./modules/M2_AUTHENTICATION.md)
3. [Module 3: Question System](./modules/M3_QUESTION_SYSTEM.md)
4. [Module 4: Value Portrait Engine](./modules/M4_VALUE_PORTRAIT_ENGINE.md)
5. [Module 5: Political Actor Management](./modules/M5_POLITICAL_ACTORS.md)
6. [Module 6: Alignment Engine](./modules/M6_ALIGNMENT_ENGINE.md)
7. [Module 7: User Interface](./modules/M7_USER_INTERFACE.md)

---

**Document Version**: 1.0
**Last Updated**: 2026-01-15
**Owner**: Product Manager
**Status**: Ready for Review
