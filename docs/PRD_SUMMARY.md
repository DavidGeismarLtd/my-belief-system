# First Principles - PRD Summary

## 📋 Documentation Complete

A comprehensive Product Requirements Document suite has been created for **First Principles**, consisting of 11 detailed documents covering all aspects of the product.

---

## 📚 What's Been Created

### Complete PRD Suite (11 Documents)

All documents are located in `/docs/prd/`:

1. **00-overview.md** - Executive summary and navigation guide
2. **01-product-vision.md** - Vision, mission, and core principles
3. **02-user-personas.md** - Target users, use cases, and user journeys
4. **03-value-portrait-system.md** - User value modeling system (8 dimensions)
5. **04-political-actor-monitoring.md** - Political actor tracking and data collection
6. **05-alignment-engine.md** - Alignment calculation algorithms and presentation
7. **06-user-experience.md** - UI/UX specifications and design system
8. **07-data-architecture.md** - Database schema and data models
9. **08-technical-architecture.md** - System design and infrastructure
10. **09-implementation-roadmap.md** - Phased delivery plan (MVP → V1.0 → V1.5)
11. **10-success-metrics.md** - KPIs and measurement framework

Plus a **README.md** that serves as the entry point for all stakeholders.

---

## 🎯 Product Overview

### One-Sentence Description
> First Principles helps you understand how political actors align with your values — and how that alignment changes over time — beyond rhetoric, headlines, and short-term memory.

### Core Innovation
Unlike political quizzes that give you a one-time label, First Principles:
- Creates a **persistent value portrait** you can refine over time
- **Continuously tracks** political actors' positions
- Shows **how alignment changes** over months and years
- Provides **long-term political memory**

---

## 🏗️ System Architecture

### The Two Pillars

**1. Value Portrait System**
- 8 core political dimensions (liberty vs authority, economic equality, etc.)
- Quantitative model: position (-1 to +1), intensity (0-1), confidence (0-1)
- Built through adaptive questioning (15-20 min onboarding)
- User can refine and update over time

**2. Political Actor Monitoring**
- Automated data collection from votes, speeches, statements
- NLP-powered position extraction
- Tiered source weighting (actions > formal commitments > statements)
- Continuous portrait updates for parties and politicians

### Alignment Engine
- Dimension-by-dimension comparison
- Weighted by user's intensity and confidence
- Change detection (drift, reversals, contradictions)
- Explainable results with evidence links

---

## 🚀 Implementation Plan

### Phase 1: MVP (Months 1-4)
**Goal**: Validate core concept with 100 early adopters

**Scope**:
- Basic value portrait creation
- 2-4 parties, 5 personalities (manually curated)
- Simple alignment calculation
- Basic dashboard

**Success**: 60% Day 7 retention, 4.0+ CSAT

---

### Phase 2: V1.0 Public Launch (Months 5-8)
**Goal**: Full-featured product for 5,000 users

**Scope**:
- Automated data collection (APIs, web scraping)
- 50+ actors with historical data
- Change detection and notifications
- Polished UX with timelines and comparisons

**Success**: 40% WAU, 40+ NPS

---

### Phase 3: V1.5 Enhancements (Months 9-12)
**Goal**: Scale to 25,000 users and expand internationally

**Scope**:
- LLM-powered NLP (GPT-4/Claude)
- UK political actors
- Advanced features (what-if scenarios, election mode)
- Mobile apps

**Success**: 50% WAU, 50+ NPS

---

## 💻 Technology Stack

### Current (Rails App)
- **Backend**: Ruby on Rails 8.1+
- **Database**: PostgreSQL 15+
- **Frontend**: React 18+ with TypeScript
- **Styling**: Tailwind CSS
- **Jobs**: Sidekiq
- **Cache**: Redis

### Infrastructure
- **MVP**: Heroku
- **V1.0+**: AWS (EC2, RDS, S3)
- **CDN**: CloudFront
- **Monitoring**: Sentry + DataDog

---

## 📊 Key Metrics

### North Star Metric
**Weekly Active Users who check alignment updates** (Target: 40%)

### Critical Metrics
- **Onboarding completion**: 70%+
- **Day 7 retention**: 60%+
- **Day 30 retention**: 40%+
- **Portrait accuracy** (self-reported): 80%+
- **NPS**: 40+ (V1.0)
- **Data errors**: <5% user-reported

---

## 🎨 Design Principles

1. **Neutral, calm tone** - No partisan framing or outrage
2. **No score obsession** - Alignment is nuanced, not gamified
3. **Explain before judging** - Context and reasoning always visible
4. **Uncertainty is a feature** - Ambiguity surfaced, not hidden
5. **Long-term memory** - Track changes over time

---

## 🚫 What We DON'T Do

- ❌ No voting recommendations
- ❌ No "best match" gamification
- ❌ No moral judgments
- ❌ No outrage-driven alerts
- ❌ No social features or viral mechanics
- ❌ No pay-to-influence

---

## 👥 Target Users

### Primary Personas
1. **The Thoughtful Voter** - Wants informed decisions, not tribal ones
2. **The Politically Curious** - New to politics, resists labels
3. **The Disillusioned Partisan** - Feels party has changed
4. **The Policy Wonk** - Wants granular, evidence-based analysis

---

## 📈 Next Steps

1. **Review & Approve**: Stakeholders review all 11 PRD documents
2. **Technical Spike**: Validate value portrait calculation algorithm
3. **Design Mockups**: Create high-fidelity designs for onboarding flow
4. **MVP Kickoff**: Begin Month 1 development
5. **Question Bank**: Write and test initial 24 questions

---

## 📖 How to Use This Documentation

### For Product Team
Start with `00-overview.md`, then `01-product-vision.md`, then `09-implementation-roadmap.md`

### For Engineering
Focus on `07-data-architecture.md`, `08-technical-architecture.md`, and `09-implementation-roadmap.md`

### For Design
Review `02-user-personas.md`, `06-user-experience.md`, and `03-value-portrait-system.md`

### For Data/ML
Study `03-value-portrait-system.md`, `04-political-actor-monitoring.md`, and `05-alignment-engine.md`

---

## ✅ Deliverables Checklist

- [x] Product vision and principles
- [x] User personas and use cases
- [x] Value portrait system specification
- [x] Political actor monitoring system
- [x] Alignment engine algorithms
- [x] UI/UX specifications
- [x] Complete database schema
- [x] Technical architecture
- [x] Phased implementation roadmap
- [x] Success metrics and KPIs
- [x] Navigation and summary docs

---

**All PRD documents are ready for review and implementation.**

For questions or to begin development, see `/docs/prd/README.md`

