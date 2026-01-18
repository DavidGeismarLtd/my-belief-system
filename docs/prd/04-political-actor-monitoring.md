# Political Actor Monitoring System

## Overview

The **Political Actor Monitoring System** continuously tracks what political parties and personalities stand for, creating value portraits for each actor that can be compared to user portraits.

## Actor Types

### 1. Political Parties
**Definition**: Formal political organizations with official platforms

**Examples**: Democratic Party (US), Conservative Party (UK), La République En Marche (France)

**Data Sources**:
- Official party platforms and manifestos
- Voting records of party members
- Official party statements
- Leadership speeches

---

### 2. Political Personalities
**Definition**: Individual politicians, candidates, or political figures

**Examples**: Presidents, Prime Ministers, Senators, Governors, Candidates

**Data Sources**:
- Personal voting record
- Campaign speeches and materials
- Official statements
- Media interviews
- Social media (weighted lower)

---

### 3. Political Movements (Future)
**Definition**: Non-party political organizations or coalitions

**Examples**: Tea Party, Occupy Wall Street, Extinction Rebellion

---

## Data Sources

### Source Hierarchy (by commitment level)

#### Tier 1: Actions (Highest Weight)
**Weight**: 1.0

**Sources**:
- Legislative votes
- Executive orders
- Budget allocations
- Treaty signatures
- Judicial appointments

**Rationale**: Actions reveal true priorities more than words

---

#### Tier 2: Formal Commitments (High Weight)
**Weight**: 0.8

**Sources**:
- Party platforms
- Campaign manifestos
- Official policy documents
- Sworn testimony
- Formal speeches (State of Union, etc.)

**Rationale**: Public, formal commitments carry accountability

---

#### Tier 3: Public Statements (Medium Weight)
**Weight**: 0.5

**Sources**:
- Press releases
- Press conference statements
- Prepared remarks
- Op-eds and articles
- Official interviews

**Rationale**: Public but less formal, more subject to rhetoric

---

#### Tier 4: Informal Communication (Low Weight)
**Weight**: 0.2

**Sources**:
- Social media posts
- Rally speeches
- Informal interviews
- Leaked communications

**Rationale**: Often performative, less reliable indicator of actual positions

---

## Value Extraction Process

### Step 1: Data Collection

**Automated Collection**:
- RSS feeds from official sources
- API integrations (e.g., ProPublica Congress API, GovTrack)
- Web scraping of official sites
- Social media APIs

**Manual Collection** (for MVP):
- Curated list of major speeches
- Key policy documents
- Voting records from official sources

**Frequency**:
- Voting records: Daily
- Official statements: Daily
- Party platforms: As published
- Social media: Hourly (but low weight)

---

### Step 2: Content Analysis

**Natural Language Processing**:
1. **Extract policy positions** from text
2. **Map positions to value dimensions**
3. **Determine direction** (which pole of dimension)
4. **Assess intensity** (how strongly stated)
5. **Calculate confidence** (how clear the statement)

**Example**:

**Input**: "We must implement a carbon tax to combat climate change, even if it slows economic growth in the short term."

**Analysis**:
- **Dimension**: Environmental Protection vs Economic Growth
- **Position**: +0.7 (toward Environmental Protection)
- **Intensity**: 0.8 (strong statement)
- **Confidence**: 0.9 (very clear)
- **Source tier**: 2 (formal speech)
- **Weight**: 0.8 * 0.9 = 0.72

---

### Step 3: Value Portrait Construction

**Aggregation**:
- Combine all statements/actions for an actor
- Weight by source tier and confidence
- Calculate position on each dimension
- Track changes over time

**Actor Value Portrait Structure**:
```
ActorValuePortrait {
  actor_id: UUID
  actor_type: "party" | "personality"
  created_at: DateTime
  updated_at: DateTime
  
  dimensions: [
    {
      dimension_id: String
      current_position: Float (-1 to +1)
      intensity: Float (0-1)
      confidence: Float (0-1)
      
      history: [
        {
          timestamp: DateTime
          position: Float
          source_id: String
          source_type: String
          weight: Float
        }
      ]
    }
  ]
}
```

---

### Step 4: Change Detection

**Types of Changes**:

1. **Drift**: Gradual shift over time
   - Example: Party moves from -0.3 to +0.2 on economic equality over 5 years

2. **Reversal**: Sudden flip
   - Example: Politician votes against a policy they previously supported

3. **Contradiction**: Conflicting positions
   - Example: Statement supports liberty, but vote supports authority

4. **Intensification**: Same direction, stronger position
   - Example: Moderate support becomes strong support

**Detection Algorithm**:
```
For each dimension:
  - Compare current position to position 30/90/365 days ago
  - If change > threshold (e.g., 0.3), flag as significant
  - Classify change type
  - Identify triggering events/statements
```

---

## Actor Coverage

### MVP Coverage (US-focused)

**Parties**:
- Democratic Party
- Republican Party
- Libertarian Party (optional)
- Green Party (optional)

**Personalities** (minimum):
- Current President
- Major presidential candidates
- Senate Majority/Minority Leaders
- House Speaker
- Governors of 5 largest states

**Total**: 2-4 parties, 15-20 personalities

---

### Expansion Plan

**Phase 2**: 
- All US Senators and Representatives
- All US Governors
- Major mayoral candidates in top 20 cities

**Phase 3**:
- UK political actors
- EU political actors
- Other democracies

---

## Data Quality & Validation

### Quality Checks

1. **Source verification**: Is source authentic?
2. **Context check**: Is statement taken out of context?
3. **Recency**: Is data current?
4. **Completeness**: Do we have coverage across all dimensions?

### Human Review

**When required**:
- New actor added to system
- Significant change detected (>0.5 shift)
- User reports inaccuracy
- Contradictory data from high-weight sources

**Review process**:
1. Content team reviews flagged item
2. Verifies source and context
3. Adjusts weight or removes if inaccurate
4. Documents decision

---

## Actor Profile Page

### Components

**1. Header**
- Actor name and photo
- Actor type (party/personality)
- Current office/role
- Last updated timestamp

**2. Value Portrait Visualization**
- Radar chart showing positions on 8 dimensions
- Confidence indicators
- Comparison toggle (vs user's portrait)

**3. Dimension Details**
- List view of each dimension
- Current position with explanation
- Recent changes highlighted
- Evidence links

**4. Timeline**
- Historical view of position changes
- Key events marked
- Filter by dimension

**5. Evidence**
- List of statements/actions
- Sorted by recency or relevance
- Links to original sources
- Source tier indicated

**6. Contradictions** (if any)
- Highlighted inconsistencies
- Explanation of conflict
- User can provide context

---

## Update Frequency

### Real-time Updates
- Legislative votes (within 1 hour)
- Major speeches (within 4 hours)
- Official statements (within 24 hours)

### Batch Updates
- Social media (daily aggregation)
- Historical data backfill (weekly)
- Portrait recalculation (daily)

### User Notifications

Users notified when:
- Significant change in tracked actor (>0.3 shift)
- Contradiction detected in tracked actor
- New major policy statement from tracked actor
- Election approaching for tracked actor

**Notification settings**:
- Frequency: Immediate / Daily digest / Weekly digest / Off
- Threshold: Major changes only / All changes
- Actors: All tracked / Selected only

---

## Data Model

### Actor Entity
```
Actor {
  id: UUID
  type: "party" | "personality"
  name: String
  country: String
  jurisdiction: String (e.g., "federal", "california")
  office: String (e.g., "President", "Senator")
  party_affiliation: String (for personalities)
  active: Boolean
  created_at: DateTime
  updated_at: DateTime
}
```

### Source Entity
```
Source {
  id: UUID
  actor_id: UUID
  type: "vote" | "speech" | "platform" | "statement" | "social_media"
  tier: Integer (1-4)
  title: String
  content: Text
  url: String
  published_at: DateTime
  collected_at: DateTime
  processed: Boolean
}
```

### Position Entity
```
Position {
  id: UUID
  actor_id: UUID
  source_id: UUID
  dimension_id: String
  position: Float (-1 to +1)
  intensity: Float (0-1)
  confidence: Float (0-1)
  weight: Float (0-1)
  extracted_at: DateTime
}
```

---

**Next**: [05-alignment-engine.md](./05-alignment-engine.md) - How we calculate and present alignment

