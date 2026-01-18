# First Principles - Technical Documentation

Welcome to the technical documentation for First Principles MVP implementation.

---

## 📚 Documentation Index

### Master Planning Documents

1. **[Master Development Plan](./MASTER_DEVELOPMENT_PLAN.md)** ⭐ START HERE
   - Complete 16-week timeline
   - Module breakdown and dependencies
   - Resource allocation
   - Risk assessment
   - Testing strategy
   - Deployment plan

2. **[MVP Modules Overview](./MVP_MODULES_OVERVIEW.md)** 
   - Quick reference for all 7 modules
   - Technical, product, and UI/UX specs
   - Integration points
   - Testing summary

---

### Module Deep-Dive Documents

Located in `/docs/technical/modules/`:

| Module | Document | Status | Weeks |
|--------|----------|--------|-------|
| M1: Database Foundation | [M1_DATABASE_FOUNDATION.md](./modules/M1_DATABASE_FOUNDATION.md) | ✅ Complete | 1-2 |
| M2: Authentication | [M2_AUTHENTICATION.md](./modules/M2_AUTHENTICATION.md) | 📝 In Progress | 3-4 |
| M3: Question System | [M3_QUESTION_SYSTEM.md](./modules/M3_QUESTION_SYSTEM.md) | 📋 Planned | 5-6 |
| M4: Value Portrait Engine | [M4_VALUE_PORTRAIT_ENGINE.md](./modules/M4_VALUE_PORTRAIT_ENGINE.md) | 📋 Planned | 7-8 |
| M5: Political Actors | [M5_POLITICAL_ACTORS.md](./modules/M5_POLITICAL_ACTORS.md) | 📋 Planned | 9-10 |
| M6: Alignment Engine | [M6_ALIGNMENT_ENGINE.md](./modules/M6_ALIGNMENT_ENGINE.md) | 📋 Planned | 11-12 |
| M7: User Interface | [M7_USER_INTERFACE.md](./modules/M7_USER_INTERFACE.md) | 📋 Planned | 13-16 |

**See**: [modules/README.md](./modules/README.md) for module index

---

## 🎯 Quick Start Guides

### For Backend Engineers

**Week 1-2: Database Foundation**
1. Read [M1_DATABASE_FOUNDATION.md](./modules/M1_DATABASE_FOUNDATION.md)
2. Set up PostgreSQL locally
3. Create migrations for 5 core tables
4. Implement ActiveRecord models
5. Seed value dimensions and questions
6. Write model tests (>90% coverage)

**Week 3-4: Authentication**
1. Read [M2_AUTHENTICATION.md](./modules/M2_AUTHENTICATION.md)
2. Install Devise and configure
3. Implement JWT authentication
4. Create auth API endpoints
5. Add Pundit for authorization
6. Security audit

**Week 5-12: Core Features**
- Follow module documents in sequence
- Each module builds on previous ones
- Maintain >90% test coverage
- Weekly code reviews

---

### For Frontend Engineers

**Week 13: Setup & Onboarding**
1. Read [M7_USER_INTERFACE.md](./modules/M7_USER_INTERFACE.md)
2. Set up React + TypeScript + Tailwind
3. Review API contracts from M2-M6
4. Implement onboarding flow
5. Build question components
6. Create radar chart visualization

**Week 14-15: Dashboard & Features**
- Build dashboard layout
- Implement actor cards
- Create alignment displays
- Add responsive design
- Accessibility audit

**Week 16: Polish & Launch**
- E2E testing
- Performance optimization
- Bug fixes
- Beta testing

---

### For Product Managers

**Planning Phase**:
1. Review [Master Development Plan](./MASTER_DEVELOPMENT_PLAN.md)
2. Validate timeline and resources
3. Review user stories in each module
4. Set up weekly progress tracking

**Execution Phase**:
- Weekly sprint planning
- Daily standups
- Review deliverables against acceptance criteria
- Manage risks and blockers

---

### For Designers

**Week 1-8: Research & Design**
1. Review [MVP Modules Overview](./MVP_MODULES_OVERVIEW.md)
2. Study UI/UX sections in each module
3. Create high-fidelity mockups
4. Design component library
5. Validate with team

**Week 9-12: Refinement**
- Iterate on designs based on backend progress
- Create responsive variants
- Accessibility review
- Prepare assets for frontend

**Week 13-16: Implementation Support**
- Work with frontend engineers
- Review implementations
- Adjust designs as needed

---

## 🏗️ Architecture Overview

### System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend (React)                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │Onboarding│  │Dashboard │  │  Actor   │             │
│  │   Flow   │  │          │  │ Details  │             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼─────────────┼────────────────────┘
        │             │             │
        │ JWT Auth    │ JWT Auth    │ JWT Auth
        ▼             ▼             ▼
┌─────────────────────────────────────────────────────────┐
│                   Rails API Layer                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │   Auth   │  │Questions │  │Alignment │             │
│  │Controller│  │Controller│  │Controller│             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼─────────────┼────────────────────┘
        │             │             │
        ▼             ▼             ▼
┌─────────────────────────────────────────────────────────┐
│                   Service Layer                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │   JWT    │  │Portrait  │  │Alignment │             │
│  │ Manager  │  │ Builder  │  │Calculator│             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼─────────────┼────────────────────┘
        │             │             │
        └─────────────┴─────────────┘
                      │
                      ▼
              ┌──────────────┐
              │  PostgreSQL  │
              │   + Redis    │
              └──────────────┘
```

---

## 📊 Module Dependencies

```
M1 (Database) - Weeks 1-2
  ↓
M2 (Auth) - Weeks 3-4
  ↓
M3 (Questions) - Weeks 5-6
  ↓
M4 (Portrait) ←─── M5 (Actors) - Weeks 9-10
  Weeks 7-8          ↓
  ↓                  ↓
  └────→ M6 (Alignment) - Weeks 11-12
           ↓
         M7 (UI) - Weeks 13-16
```

**Critical Path**: M1 → M2 → M3 → M4 → M6 → M7  
**Parallel Work**: M5 can be done alongside M4

---

## 🧪 Testing Strategy

### Coverage Targets
- **Unit Tests**: >90% for all modules
- **Integration Tests**: All API endpoints
- **E2E Tests**: 5 critical user flows

### Tools
- **Backend**: RSpec, FactoryBot, Faker
- **Frontend**: Jest, React Testing Library, Cypress
- **Performance**: rack-mini-profiler, Lighthouse
- **Security**: Brakeman, bundler-audit

### Test Pyramid
```
        E2E (5 flows)
       /              \
    Integration (All APIs)
   /                      \
Unit (>90% coverage)
```

---

## 🚀 Deployment

### Environments
1. **Development**: Local machines
2. **Staging**: Heroku staging app (Week 12)
3. **Production**: Heroku production app (Week 16)

### CI/CD Pipeline
```
Git Push → GitHub Actions → Tests → Staging → Approval → Production
```

### Infrastructure
- **Platform**: Heroku
- **Database**: PostgreSQL Standard-0
- **Cache**: Redis Premium-0
- **Monitoring**: Sentry + Heroku Metrics
- **Cost**: ~$100/month

---

## 📈 Success Metrics

### Technical Metrics
- All 7 modules completed on time
- >90% test coverage
- API response time <200ms (p95)
- Page load time <3s (p95)
- 99%+ uptime

### Product Metrics
- 100 users complete onboarding
- 60% Day 7 retention
- 4.0+ CSAT score
- 80%+ portrait accuracy (self-reported)

---

## 📞 Support & Questions

### Documentation Issues
- Create an issue in the repo
- Tag with `documentation` label

### Technical Questions
- Review module documents first
- Check [Master Development Plan](./MASTER_DEVELOPMENT_PLAN.md)
- Ask in team Slack channel

---

## 🔗 Related Documentation

- [Product Requirements (PRD)](../prd/) - Product specifications
- [Getting Started Guide](../GETTING_STARTED.md) - Development setup
- [PRD Summary](../PRD_SUMMARY.md) - Executive overview

---

**Last Updated**: 2026-01-15  
**Maintained By**: Technical Lead  
**Status**: Ready for Implementation

