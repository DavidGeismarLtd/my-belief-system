# First Principles - Product Requirements Documentation

## Welcome

This directory contains the complete Product Requirements Documentation (PRD) for **First Principles**, a political orientation tool that helps users understand how political parties and public figures align with their core values over time.

---

## Quick Start

### For Product Team
Start with:
1. [00-overview.md](./00-overview.md) - Executive summary
2. [01-product-vision.md](./01-product-vision.md) - Vision and principles
3. [09-implementation-roadmap.md](./09-implementation-roadmap.md) - What we're building when

### For Engineering Team
Focus on:
1. [07-data-architecture.md](./07-data-architecture.md) - Database schema
2. [08-technical-architecture.md](./08-technical-architecture.md) - System design
3. [09-implementation-roadmap.md](./09-implementation-roadmap.md) - Phased delivery

### For Design Team
Review:
1. [02-user-personas.md](./02-user-personas.md) - Who we're designing for
2. [06-user-experience.md](./06-user-experience.md) - UI/UX specifications
3. [03-value-portrait-system.md](./03-value-portrait-system.md) - Core user flow

### For Data/ML Team
Study:
1. [03-value-portrait-system.md](./03-value-portrait-system.md) - Value modeling
2. [04-political-actor-monitoring.md](./04-political-actor-monitoring.md) - Data collection & NLP
3. [05-alignment-engine.md](./05-alignment-engine.md) - Alignment algorithms

---

## Document Index

| # | Document | Purpose | Audience |
|---|----------|---------|----------|
| 00 | [Overview](./00-overview.md) | Executive summary and navigation | Everyone |
| 01 | [Product Vision](./01-product-vision.md) | Vision, mission, core principles | Product, Leadership |
| 02 | [User Personas](./02-user-personas.md) | Target users and use cases | Product, Design, Marketing |
| 03 | [Value Portrait System](./03-value-portrait-system.md) | User value modeling | Product, Engineering, Data |
| 04 | [Political Actor Monitoring](./04-political-actor-monitoring.md) | Actor tracking and data collection | Engineering, Data, Content |
| 05 | [Alignment Engine](./05-alignment-engine.md) | Alignment calculation and presentation | Engineering, Data, Product |
| 06 | [User Experience](./06-user-experience.md) | UI/UX specifications | Design, Frontend Engineering |
| 07 | [Data Architecture](./07-data-architecture.md) | Database schema and data models | Backend Engineering, Data |
| 08 | [Technical Architecture](./08-technical-architecture.md) | System design and infrastructure | Engineering, DevOps |
| 09 | [Implementation Roadmap](./09-implementation-roadmap.md) | Phased delivery plan | Everyone |
| 10 | [Success Metrics](./10-success-metrics.md) | KPIs and measurement | Product, Leadership, Data |

---

## Core Concepts

### The Product in One Sentence

> First Principles helps you understand how political actors align with your values — and how that alignment changes over time — beyond rhetoric, headlines, and short-term memory.

### The Two Pillars

1. **Value Portrait**: A structured, quantitative model of what the user actually cares about politically
2. **Continuous Alignment Analysis**: Ongoing evaluation of whether parties and politicians act consistently with those values

### What Makes This Different

- **Not a quiz**: Values are ongoing, not a one-time snapshot
- **Not news**: Focuses on principles, not events
- **Not partisan**: Same framework for all actors
- **Not a recommendation engine**: We inform, not prescribe

---

## Key Design Principles

1. **Neutrality Over Persuasion** - No voting recommendations
2. **Clarity Over Simplicity** - Make complexity inspectable
3. **Memory Over Novelty** - Track long-term patterns
4. **Principles Over Personalities** - Focus on what actors stand for
5. **Transparency Over Black Boxes** - Always explain how we know

---

## Development Phases

### MVP (Months 1-4)
**Goal**: Validate core concept
- Basic value portrait creation
- Manual actor data (2-4 parties, 5 personalities)
- Simple alignment calculation
- **Target**: 100 users, 60% retention

### V1.0 (Months 5-8)
**Goal**: Public launch
- Automated data collection
- 50+ actors
- Historical tracking
- Change detection
- **Target**: 5,000 users, 40% WAU

### V1.5+ (Months 9-12)
**Goal**: Scale and deepen
- LLM-powered NLP
- International expansion (UK)
- Advanced features
- **Target**: 25,000 users, 50% WAU

---

## Technology Stack

### Frontend
- React 18+ with TypeScript
- Tailwind CSS
- Recharts for visualizations

### Backend
- Ruby on Rails 8.1+ (current)
- PostgreSQL 15+
- Redis for caching
- Sidekiq for background jobs

### Infrastructure
- Heroku (MVP) → AWS (V1.0)
- CloudFront CDN
- Sentry + DataDog monitoring

---

## Getting Involved

### Contributing to PRD

This is a living document. To suggest changes:

1. **Minor edits**: Create a PR with changes
2. **Major changes**: Open an issue for discussion first
3. **New sections**: Discuss with product team

### Feedback

Questions or feedback? Contact:
- Product: [TBD]
- Engineering: [TBD]
- Design: [TBD]

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2026-01-13 | Initial PRD creation | Product Team |

---

## Related Documentation

- **Technical Docs**: `/docs/technical/` (coming soon)
- **API Docs**: `/docs/api/` (coming soon)
- **Design System**: `/docs/design/` (coming soon)
- **User Guides**: `/docs/user-guides/` (coming soon)

---

## Appendices

### Glossary

- **Value Portrait**: Structured model of a user's political values across 8 dimensions
- **Political Actor**: Party or personality being tracked
- **Alignment**: Calculated similarity between user and actor value portraits
- **Dimension**: One axis of political values (e.g., liberty vs authority)
- **Position**: Where someone stands on a dimension (-1 to +1)
- **Intensity**: How strongly someone holds a value (0 to 1)
- **Confidence**: How certain we are about a position (0 to 1)
- **Source**: Data point about an actor (vote, speech, statement)
- **Tier**: Weight of a source based on commitment level (1-4)

### References

- Political Compass: https://www.politicalcompass.org/
- ISideWith: https://www.isidewith.com/
- ProPublica Congress API: https://projects.propublica.org/api-docs/congress-api/
- GovTrack: https://www.govtrack.us/

---

## License

This documentation is proprietary and confidential.

© 2026 First Principles. All rights reserved.

