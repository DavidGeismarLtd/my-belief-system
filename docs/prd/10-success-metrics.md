# Success Metrics & KPIs

## Overview

This document defines how we measure the success of First Principles across product, business, and impact dimensions.

---

## North Star Metric

**Metric**: Weekly Active Users who check alignment updates

**Why**: This indicates users find ongoing value in the product, not just one-time curiosity. It reflects the core promise: long-term political memory and alignment tracking.

**Target**: 40% of registered users are weekly active (industry benchmark: 20-30% for content apps)

---

## Product Metrics

### 1. Onboarding & Activation

#### Onboarding Completion Rate
**Definition**: % of users who complete value portrait creation

**Target**: 
- MVP: 60%
- V1.0: 70%
- V1.5: 75%

**Measurement**: 
```
completed_portraits / started_onboarding
```

**Why it matters**: If users don't complete onboarding, they can't use the product

---

#### Time to First Value
**Definition**: Time from signup to viewing first alignment

**Target**: 
- MVP: < 25 minutes
- V1.0: < 20 minutes
- V1.5: < 15 minutes

**Why it matters**: Faster time to value = higher activation

---

#### Portrait Accuracy (Self-Reported)
**Definition**: % of users who rate their portrait as "accurate" or "very accurate"

**Target**: 80%+

**Measurement**: Post-onboarding survey: "How well does this portrait reflect your values?"
- Very accurate (5)
- Accurate (4)
- Somewhat accurate (3)
- Not very accurate (2)
- Not accurate at all (1)

**Why it matters**: If portrait is inaccurate, alignment is meaningless

---

### 2. Engagement

#### Weekly Active Users (WAU)
**Definition**: Users who log in and view content at least once per week

**Target**:
- MVP: 30%
- V1.0: 40%
- V1.5: 50%

**Measurement**: 
```
unique_users_active_in_week / total_registered_users
```

---

#### Average Session Duration
**Definition**: Mean time spent per session

**Target**: 8-12 minutes

**Why it matters**: 
- Too short (<3 min): Not engaging deeply
- Too long (>20 min): Might indicate confusion or difficulty

---

#### Actors Tracked per User
**Definition**: Mean number of actors a user actively tracks

**Target**:
- MVP: 2-3
- V1.0: 4-6
- V1.5: 6-8

**Why it matters**: More tracking = more invested in the product

---

#### Alignment Checks per Week
**Definition**: How often users view alignment details

**Target**: 2-3 times per week for active users

**Why it matters**: Core product usage

---

### 3. Retention

#### Day 7 Retention
**Definition**: % of users who return within 7 days of signup

**Target**:
- MVP: 50%
- V1.0: 60%
- V1.5: 65%

---

#### Day 30 Retention
**Definition**: % of users who return within 30 days of signup

**Target**:
- MVP: 30%
- V1.0: 40%
- V1.5: 50%

---

#### 6-Month Retention
**Definition**: % of users still active after 6 months

**Target**: 25%+

**Why it matters**: Long-term value realization

---

### 4. Data Quality

#### Source Freshness
**Definition**: % of tracked actors with data updated in last 7 days

**Target**: 90%+

**Why it matters**: Stale data = inaccurate alignment

---

#### Position Confidence
**Definition**: Average confidence score across all actor positions

**Target**: 0.70+

**Why it matters**: Low confidence = unreliable alignment

---

#### User-Reported Errors
**Definition**: Number of data errors reported per 1000 users per month

**Target**: 
- MVP: < 50
- V1.0: < 20
- V1.5: < 10

**Why it matters**: Errors erode trust

---

## User Satisfaction Metrics

### Net Promoter Score (NPS)
**Definition**: "How likely are you to recommend First Principles to a friend?" (0-10)

**Calculation**: % Promoters (9-10) - % Detractors (0-6)

**Target**:
- MVP: 20+ (acceptable)
- V1.0: 40+ (good)
- V1.5: 50+ (excellent)

**Benchmark**: Consumer apps average 30-40

---

### Customer Satisfaction (CSAT)
**Definition**: "How satisfied are you with First Principles?" (1-5)

**Target**: 4.0+ average

**Measurement**: In-app survey after key actions (onboarding, viewing alignment, etc.)

---

### Trust Score
**Definition**: "How much do you trust the alignment analysis?" (1-5)

**Target**: 4.2+ average

**Why it matters**: Trust is essential for this product

**Measurement**: Quarterly survey

---

## Impact Metrics

### Value Clarity
**Definition**: "First Principles helped me understand my own political values better"

**Target**: 70%+ agree or strongly agree

**Measurement**: Post-onboarding survey

---

### Decision Confidence
**Definition**: "I feel more confident in my political decisions because of First Principles"

**Target**: 60%+ agree or strongly agree

**Measurement**: Monthly survey to active users

---

### Reduced Reactivity
**Definition**: "I feel less reactive to political news since using First Principles"

**Target**: 50%+ agree or strongly agree

**Measurement**: 30-day survey

---

### Informed Voting
**Definition**: % of users who say First Principles influenced their voting decision

**Target**: 40%+ (among users active during election)

**Measurement**: Post-election survey

---

## Business Metrics

### User Acquisition

#### Total Registered Users
**Target**:
- MVP: 100
- V1.0: 5,000
- V1.5: 25,000
- Year 2: 100,000

---

#### Acquisition Channels
**Measurement**: Track signups by source
- Organic search
- Social media
- Press/media
- Word of mouth (referral)
- Paid ads (if applicable)

**Target**: 60%+ organic/referral (indicates product-market fit)

---

#### Cost per Acquisition (CPA)
**Target**: < $5 per user (if using paid channels)

---

### Revenue (Future)

#### Conversion to Paid
**Definition**: % of users who convert to paid subscription

**Target**: 5-10% (freemium model)

**Note**: Not applicable to MVP; consider for V1.5+

---

#### Monthly Recurring Revenue (MRR)
**Target**: TBD based on pricing model

---

#### Churn Rate
**Definition**: % of paid users who cancel per month

**Target**: < 5% monthly churn

---

## Technical Metrics

### Performance

#### Page Load Time
**Target**: < 2 seconds (p95)

---

#### API Response Time
**Target**: < 200ms (p95)

---

#### Uptime
**Target**: 99.5%+ (MVP), 99.9%+ (V1.0)

---

### Data Processing

#### Source Processing Time
**Definition**: Time from source collection to position extraction

**Target**: < 4 hours for high-priority sources

---

#### Alignment Calculation Time
**Definition**: Time to recalculate alignment after actor update

**Target**: < 5 minutes

---

## Monitoring & Reporting

### Dashboards

**Product Dashboard** (Daily):
- WAU, DAU
- Onboarding completion rate
- Retention cohorts
- Top actors tracked

**Data Quality Dashboard** (Daily):
- Source freshness
- Processing errors
- Confidence scores
- User-reported issues

**Business Dashboard** (Weekly):
- Total users
- Growth rate
- Acquisition channels
- NPS/CSAT scores

---

### Alerts

**Critical**:
- Uptime < 99%
- Error rate > 5%
- Data processing stopped

**Warning**:
- Source freshness < 80%
- Onboarding completion < 50%
- Day 7 retention < 40%

---

### Reporting Cadence

**Daily**: 
- Active users
- Errors and uptime

**Weekly**: 
- Engagement metrics
- Retention cohorts
- Data quality

**Monthly**: 
- NPS/CSAT surveys
- User growth
- Feature usage

**Quarterly**: 
- Impact metrics
- Strategic review
- Roadmap adjustment

---

## Success Criteria by Phase

### MVP Success
- ✅ 100 users complete onboarding
- ✅ 60% Day 7 retention
- ✅ 4.0+ CSAT
- ✅ 70%+ say "helped me understand my values"

### V1.0 Success
- ✅ 5,000 total users
- ✅ 40% WAU
- ✅ 40+ NPS
- ✅ <5% user-reported errors

### V1.5 Success
- ✅ 25,000 total users
- ✅ 50% WAU
- ✅ 50+ NPS
- ✅ 60%+ say "more confident in political decisions"

---

**End of PRD Suite**

For questions or feedback, contact the product team.

