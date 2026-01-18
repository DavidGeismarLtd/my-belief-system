# First Principles - Documentation

Welcome to the First Principles documentation repository.

---

## 📚 Available Documentation

### Product Requirements (PRD)
**Location**: [`/docs/prd/`](./prd/)

Complete product specification including:
- Product vision and principles
- User personas and use cases  
- Technical architecture
- Implementation roadmap
- Success metrics

**Start here**: [`/docs/prd/README.md`](./prd/README.md)

**Quick summary**: [`/docs/PRD_SUMMARY.md`](./PRD_SUMMARY.md)

---

## 🎯 What is First Principles?

First Principles is a political orientation tool that helps users understand how political parties and public figures align with their core values over time.

### Key Features

1. **Value Portrait** - Create a structured model of your political values across 8 dimensions
2. **Actor Monitoring** - Track political parties and personalities continuously
3. **Alignment Analysis** - See how actors align with your values, with explanations
4. **Change Detection** - Get notified when alignment shifts over time
5. **Long-term Memory** - Track changes over months and years, not just snapshots

### What Makes It Different

- **Not a quiz**: Ongoing value tracking, not one-time labels
- **Not news**: Principle-driven, not event-driven
- **Not partisan**: Same framework for all political actors
- **Not prescriptive**: We inform, we don't recommend

---

## 🚀 Quick Links

### For Product Team
- [Product Vision](./prd/01-product-vision.md)
- [User Personas](./prd/02-user-personas.md)
- [Implementation Roadmap](./prd/09-implementation-roadmap.md)
- [Success Metrics](./prd/10-success-metrics.md)

### For Engineering Team
- [Technical Architecture](./prd/08-technical-architecture.md)
- [Data Architecture](./prd/07-data-architecture.md)
- [Value Portrait System](./prd/03-value-portrait-system.md)
- [Alignment Engine](./prd/05-alignment-engine.md)

### For Design Team
- [User Experience](./prd/06-user-experience.md)
- [User Personas](./prd/02-user-personas.md)
- [Value Portrait System](./prd/03-value-portrait-system.md)

### For Data/ML Team
- [Political Actor Monitoring](./prd/04-political-actor-monitoring.md)
- [Alignment Engine](./prd/05-alignment-engine.md)
- [Value Portrait System](./prd/03-value-portrait-system.md)

---

## 📖 Documentation Structure

```
docs/
├── README.md (this file)
├── PRD_SUMMARY.md (executive summary)
└── prd/
    ├── README.md (PRD index)
    ├── 00-overview.md
    ├── 01-product-vision.md
    ├── 02-user-personas.md
    ├── 03-value-portrait-system.md
    ├── 04-political-actor-monitoring.md
    ├── 05-alignment-engine.md
    ├── 06-user-experience.md
    ├── 07-data-architecture.md
    ├── 08-technical-architecture.md
    ├── 09-implementation-roadmap.md
    └── 10-success-metrics.md
```

---

## 🏗️ System Overview

### Architecture

```
User → React Frontend → Rails API → PostgreSQL
                           ↓
                    Background Jobs
                           ↓
                  External Data Sources
```

### Core Components

1. **Value Portrait Builder** - Converts user answers into quantitative value model
2. **Actor Monitor** - Collects and analyzes political actor data
3. **Alignment Engine** - Calculates and explains alignment scores
4. **Change Detector** - Identifies significant shifts in alignment

### Technology Stack

- **Frontend**: React 18+ with TypeScript, Tailwind CSS
- **Backend**: Ruby on Rails 8.1+
- **Database**: PostgreSQL 15+
- **Cache**: Redis
- **Jobs**: Sidekiq
- **Hosting**: Heroku (MVP) → AWS (V1.0+)

---

## 📅 Implementation Timeline

### MVP (Months 1-4)
- Basic value portrait creation
- Manual actor data (2-4 parties, 5 personalities)
- Simple alignment calculation
- **Target**: 100 users, 60% Day 7 retention

### V1.0 (Months 5-8)
- Automated data collection
- 50+ actors with historical data
- Change detection and notifications
- **Target**: 5,000 users, 40% WAU

### V1.5 (Months 9-12)
- LLM-powered NLP
- International expansion (UK)
- Advanced features
- **Target**: 25,000 users, 50% WAU

---

## 📊 Success Metrics

### North Star Metric
**Weekly Active Users who check alignment updates** (Target: 40%)

### Key Metrics
- Onboarding completion: 70%+
- Day 7 retention: 60%+
- Day 30 retention: 40%+
- Portrait accuracy: 80%+
- NPS: 40+ (V1.0)

---

## 🤝 Contributing

This documentation is a living resource. To contribute:

1. Review existing docs before making changes
2. For minor edits, create a PR
3. For major changes, open an issue for discussion
4. Keep documentation in sync with implementation

---

## 📞 Contact

- **Product**: [TBD]
- **Engineering**: [TBD]
- **Design**: [TBD]

---

## 📄 License

This documentation is proprietary and confidential.

© 2026 First Principles. All rights reserved.

