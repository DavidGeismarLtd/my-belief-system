# Implementation Roadmap

## Overview

This document outlines a phased approach to building First Principles, prioritizing core functionality and user value while managing technical complexity.

---

## Release Strategy

### MVP (Minimum Viable Product)
**Goal**: Validate core concept with early adopters
**Timeline**: 3-4 months
**Scope**: Basic value portrait + limited actor tracking

### V1.0 (Public Launch)
**Goal**: Full-featured product for general audience
**Timeline**: 6-8 months from start
**Scope**: Complete feature set, polished UX

### V1.5+ (Enhancements)
**Goal**: Scale and deepen
**Timeline**: Ongoing
**Scope**: More actors, better NLP, international expansion

---

## Phase 1: MVP (Months 1-4)

### Goals
1. Users can create a value portrait
2. Users can see alignment with 2-4 major political parties
3. Basic actor tracking (manual data entry)
4. Validate product-market fit

### Features

#### Core Features (Must Have)
- ✅ User authentication (email/password)
- ✅ Onboarding flow with 20-24 questions
- ✅ Value portrait generation and visualization
- ✅ Actor profiles (4 parties, 5 personalities - manually curated)
- ✅ Alignment calculation and display
- ✅ Basic dashboard showing tracked actors
- ✅ Dimension detail views

#### Nice to Have
- ⭕ Manual portrait refinement
- ⭕ Historical alignment (last 30 days only)
- ⭕ Email notifications (weekly digest)

#### Explicitly Out of Scope
- ❌ Automated data collection
- ❌ NLP/content analysis
- ❌ Social features
- ❌ Mobile apps (web only)
- ❌ International actors (US only)

### Technical Scope

**Backend**:
- Rails API with core models (User, ValuePortrait, Actor, Alignment)
- PostgreSQL database
- Basic alignment calculation algorithm
- Manual admin interface for actor data entry

**Frontend**:
- React SPA with core screens (onboarding, dashboard, actor detail)
- Radar chart visualization
- Responsive design (mobile web)

**Infrastructure**:
- Heroku deployment
- PostgreSQL on Heroku
- Basic monitoring (Heroku metrics)

### Data Scope

**Actors** (manually curated):
- 2 parties: Democratic Party, Republican Party
- 5 personalities: Current President, 2 Senators, 2 Representatives
- Data sources: Official platforms, recent major speeches (manually entered)

**Value Dimensions**: All 8 core dimensions

**Questions**: 3 questions per dimension (24 total)

### Success Metrics (MVP)

- **Acquisition**: 100 users complete onboarding
- **Engagement**: 60% return within 7 days
- **Satisfaction**: 4+ star average rating
- **Validation**: 70% say "this helped me understand my values"

### MVP Timeline

**Month 1: Foundation**
- Week 1-2: Database schema, core models
- Week 3-4: Authentication, user management

**Month 2: Value Portrait**
- Week 1-2: Question system, onboarding flow
- Week 3-4: Portrait calculation, visualization

**Month 3: Alignment**
- Week 1-2: Actor models, manual data entry
- Week 3-4: Alignment calculation, dashboard

**Month 4: Polish & Launch**
- Week 1-2: UI polish, bug fixes
- Week 3: Beta testing with 20 users
- Week 4: MVP launch to early adopters

---

## Phase 2: V1.0 Public Launch (Months 5-8)

### Goals
1. Automated actor data collection
2. Expanded actor coverage
3. Historical tracking and change detection
4. Polished, production-ready UX

### New Features

#### Core Additions
- ✅ Automated source collection (APIs, web scraping)
- ✅ Basic NLP for position extraction
- ✅ Historical alignment tracking (6+ months)
- ✅ Change detection and notifications
- ✅ Actor comparison view
- ✅ Evidence view (sources for positions)
- ✅ Portrait refinement tools
- ✅ Export functionality (PDF reports)

#### Enhanced Features
- ✅ Advanced filtering and search
- ✅ Customizable notification preferences
- ✅ Dimension importance weighting
- ✅ Timeline visualizations
- ✅ Contradiction detection

### Technical Additions

**Backend**:
- Sidekiq for background jobs
- Redis for caching
- Source collection services (ProPublica API, GovTrack)
- Basic NLP pipeline (keyword-based)
- Change detection algorithm

**Frontend**:
- Timeline components
- Comparison views
- Advanced filtering
- Export functionality

**Infrastructure**:
- AWS migration (EC2, RDS, S3)
- CloudFront CDN
- Sentry error tracking
- DataDog monitoring

### Data Expansion

**Actors**:
- 4 parties (add Libertarian, Green)
- 50+ personalities (all Senators, key Representatives, Governors)
- Historical data: 12 months back

**Sources**:
- Voting records (automated via ProPublica API)
- Official statements (RSS feeds)
- Party platforms (manual + automated)

### Success Metrics (V1.0)

- **Acquisition**: 5,000 users in first 3 months
- **Engagement**: 40% weekly active users
- **Retention**: 50% return after 30 days
- **Satisfaction**: 4.5+ star average
- **Accuracy**: <5% user-reported data errors

### V1.0 Timeline

**Month 5: Data Infrastructure**
- Week 1-2: Source collection system
- Week 3-4: Basic NLP pipeline

**Month 6: Historical Tracking**
- Week 1-2: Timeline data models
- Week 3-4: Change detection algorithm

**Month 7: UX Enhancement**
- Week 1-2: Comparison views, advanced filtering
- Week 3-4: Notifications, export

**Month 8: Launch Prep**
- Week 1-2: Performance optimization
- Week 3: Beta testing with 200 users
- Week 4: Public launch

---

## Phase 3: V1.5 Enhancements (Months 9-12)

### Goals
1. Improve NLP accuracy
2. Expand actor coverage
3. Add advanced features
4. International expansion (UK)

### New Features

- ✅ LLM-powered content analysis (GPT-4/Claude)
- ✅ Contradiction explanations
- ✅ "What if" scenarios (adjust your values, see impact)
- ✅ Election mode (focused views for upcoming elections)
- ✅ UK political actors
- ⭕ Mobile apps (iOS, Android)
- ⭕ Social sharing (limited, non-viral)

### Technical Enhancements

- LLM integration for NLP
- Elasticsearch for advanced search
- GraphQL API (in addition to REST)
- Real-time updates (WebSockets)

### Data Expansion

**US**:
- All Representatives
- Major mayoral candidates
- State-level parties

**UK**:
- Major parties (Conservative, Labour, Lib Dem, SNP, Green)
- Key MPs and ministers

### Success Metrics (V1.5)

- **Acquisition**: 25,000 total users
- **Engagement**: 50% weekly active
- **Retention**: 60% 30-day retention
- **Accuracy**: <2% data errors
- **NPS**: 40+ (promoters - detractors)

---

## Phase 4: Scale & Deepen (Year 2+)

### Potential Features

**Geographic Expansion**:
- EU countries (France, Germany, etc.)
- Canada, Australia, New Zealand
- Emerging democracies

**Feature Depth**:
- Issue-specific deep dives
- Local politics (city councils, school boards)
- Ballot measure analysis
- Political movement tracking

**Advanced Analytics**:
- Predictive alignment (how might actor change)
- Cohort analysis (how do similar users align)
- Value drift detection (how user values change)

**Platform Expansion**:
- Native mobile apps
- Browser extensions
- API for third-party integrations

---

## Development Priorities

### Priority 1: Core Value Delivery
- Value portrait accuracy
- Alignment calculation correctness
- Data quality and freshness

### Priority 2: User Trust
- Transparency in methodology
- Source attribution
- Uncertainty communication
- Privacy protection

### Priority 3: Usability
- Smooth onboarding
- Intuitive navigation
- Fast performance
- Mobile experience

### Priority 4: Scale
- Automated data collection
- Efficient processing
- Cost optimization

---

## Risk Mitigation

### Technical Risks

**Risk**: NLP accuracy too low
**Mitigation**: Start with manual curation, gradually automate; use LLMs for complex analysis

**Risk**: Data collection breaks (API changes, scraping blocked)
**Mitigation**: Multiple data sources, manual fallback, community reporting

**Risk**: Performance issues at scale
**Mitigation**: Caching strategy, background processing, database optimization

### Product Risks

**Risk**: Users don't trust the system
**Mitigation**: Extreme transparency, show sources, allow corrections

**Risk**: Perceived political bias
**Mitigation**: Same framework for all actors, diverse test users, public methodology

**Risk**: Low engagement after onboarding
**Mitigation**: Notification strategy, election-time relevance, regular updates

### Business Risks

**Risk**: Can't monetize without compromising neutrality
**Mitigation**: Subscription model, no ads, no pay-to-influence

**Risk**: Legal challenges from political actors
**Mitigation**: Fair use, factual reporting, clear disclaimers

---

## Resource Requirements

### MVP (Phase 1)
- 1 Full-stack engineer (Rails + React)
- 1 Designer (part-time)
- 1 Product manager (part-time)
- 1 Content curator (part-time)

### V1.0 (Phase 2)
- 2 Backend engineers
- 1 Frontend engineer
- 1 Data engineer
- 1 Designer
- 1 Product manager
- 2 Content curators

### V1.5+ (Phase 3+)
- 3-4 Engineers
- 1-2 Data scientists
- 1 Designer
- 1 Product manager
- 3-4 Content curators
- 1 DevOps engineer

---

**Next**: [10-success-metrics.md](./10-success-metrics.md) - How we measure success

