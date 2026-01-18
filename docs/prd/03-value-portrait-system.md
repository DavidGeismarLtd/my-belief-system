# Value Portrait System

## Overview

The **Value Portrait System** is the foundation of First Principles. It creates a structured, quantitative model of a user's political values that is:
- **Explicit**: Values are named and defined
- **Quantitative**: Direction, intensity, and confidence are measured
- **Explainable**: Users can see why the system believes they hold each value
- **Revisable**: Users can refine or correct their portrait
- **Stable**: Portrait persists over time, allowing comparison

## Value Dimensions

### Core Dimensions (MVP)

We model political values across **8 core dimensions**:

#### 1. Individual Liberty vs Collective Authority
**Definition**: The balance between personal freedom and state/collective control

**Spectrum**:
- **Liberty pole**: Minimal government intervention, maximum personal choice
- **Authority pole**: Strong collective governance, regulated behavior for common good

**Example questions**:
- "Should the government regulate what businesses can do, or let the market decide?"
- "Is personal freedom more important than social order?"

---

#### 2. Economic Equality vs Economic Hierarchy
**Definition**: How economic resources and opportunities should be distributed

**Spectrum**:
- **Equality pole**: Wealth redistribution, progressive taxation, strong safety net
- **Hierarchy pole**: Merit-based outcomes, minimal redistribution, market-driven distribution

**Example questions**:
- "Should the government reduce income inequality through taxation?"
- "Are economic outcomes primarily the result of individual effort or systemic factors?"

---

#### 3. National Sovereignty vs International Cooperation
**Definition**: The role of the nation-state vs global institutions

**Spectrum**:
- **Sovereignty pole**: National interests first, border control, limited international obligations
- **Cooperation pole**: Global governance, open borders, international treaties

**Example questions**:
- "Should international agreements override national laws?"
- "Is immigration primarily an opportunity or a risk?"

---

#### 4. Tradition vs Progress
**Definition**: The value of established norms vs social change

**Spectrum**:
- **Tradition pole**: Preserve cultural heritage, cautious change, respect for institutions
- **Progress pole**: Embrace social change, challenge norms, reform institutions

**Example questions**:
- "Should society preserve traditional family structures or embrace new forms?"
- "Is rapid social change generally positive or destabilizing?"

---

#### 5. Environmental Protection vs Economic Growth
**Definition**: Trade-offs between ecological preservation and economic development

**Spectrum**:
- **Protection pole**: Strict environmental regulation, precautionary principle, sustainability first
- **Growth pole**: Economic development priority, market-based solutions, human needs first

**Example questions**:
- "Should environmental protection limit economic growth?"
- "Is climate change an existential threat requiring immediate action?"

---

#### 6. Direct Democracy vs Representative Democracy
**Definition**: How political decisions should be made

**Spectrum**:
- **Direct pole**: Referendums, citizen assemblies, decentralized decision-making
- **Representative pole**: Elected officials, expert governance, institutional stability

**Example questions**:
- "Should major policy decisions be made by referendum or elected representatives?"
- "Do citizens or experts make better policy decisions?"

---

#### 7. Secularism vs Religious Values
**Definition**: The role of religion in public life and policy

**Spectrum**:
- **Secular pole**: Strict separation of church and state, secular ethics
- **Religious pole**: Faith-based values in policy, religious freedom prioritized

**Example questions**:
- "Should religious values inform public policy?"
- "Is morality possible without religious foundation?"

---

#### 8. Punitive vs Rehabilitative Justice
**Definition**: The purpose and approach of the justice system

**Spectrum**:
- **Punitive pole**: Punishment, deterrence, accountability, victim focus
- **Rehabilitative pole**: Reform, root causes, reintegration, systemic focus

**Example questions**:
- "Is the primary purpose of prison punishment or rehabilitation?"
- "Should criminal justice focus on individual accountability or systemic factors?"

---

## Value Portrait Data Model

### Structure

Each user's value portrait consists of:

```
ValuePortrait {
  user_id: UUID
  created_at: DateTime
  updated_at: DateTime
  confidence_level: Float (0-1, overall portrait confidence)

  dimensions: [
    {
      dimension_id: String (e.g., "liberty_authority")
      position: Float (-1 to +1, where -1 is left pole, +1 is right pole, 0 is neutral)
      intensity: Float (0-1, how strongly held)
      confidence: Float (0-1, how certain we are)
      evidence: [
        {
          question_id: String
          answer: String
          weight: Float
          timestamp: DateTime
        }
      ]
    }
  ]
}
```

### Example

```json
{
  "user_id": "user_123",
  "created_at": "2026-01-13T10:00:00Z",
  "updated_at": "2026-01-13T10:30:00Z",
  "confidence_level": 0.82,
  "dimensions": [
    {
      "dimension_id": "liberty_authority",
      "position": -0.6,
      "intensity": 0.8,
      "confidence": 0.85,
      "evidence": [
        {
          "question_id": "q_liberty_01",
          "answer": "strongly_agree",
          "weight": 0.3,
          "timestamp": "2026-01-13T10:05:00Z"
        }
      ]
    }
  ]
}
```

**Interpretation**: User leans toward liberty (position -0.6), feels strongly about it (intensity 0.8), and we're quite confident in this assessment (confidence 0.85).

---

## Onboarding Flow

### Goal
Build an accurate value portrait in 15-20 minutes without overwhelming the user.

### Approach: Adaptive Questioning

1. **Start with broad questions** across all dimensions
2. **Adapt based on answers** - ask follow-ups where uncertainty is high
3. **Use multiple question types** to triangulate values
4. **Show progress** and allow breaks

### Question Types

#### Type 1: Direct Value Statements
"Rate your agreement: Personal freedom is more important than social order."
- Strongly Disagree / Disagree / Neutral / Agree / Strongly Agree

#### Type 2: Policy Preferences
"Should the government provide universal healthcare?"
- Yes, fully government-run / Yes, with private option / No, private only / Unsure

#### Type 3: Trade-off Scenarios
"A policy would reduce carbon emissions by 30% but slow economic growth by 2%. Do you support it?"
- Strongly Support / Support / Oppose / Strongly Oppose

#### Type 4: Concrete Dilemmas
"Your country can either: (A) Accept 100,000 refugees or (B) Invest $1B in domestic poverty programs. Which do you choose?"
- Definitely A / Probably A / Unsure / Probably B / Definitely B

### Onboarding Steps

**Step 1: Welcome & Explanation** (2 min)
- Explain what value portrait is
- Set expectations (15-20 min, can pause)
- Emphasize: no right answers, can refine later

**Step 2: Core Questions** (10 min)
- 2-3 questions per dimension (16-24 total)
- Mix question types
- Show progress bar

**Step 3: Adaptive Deep-Dive** (5 min)
- Focus on dimensions with low confidence
- Ask clarifying questions
- Allow "skip" option

**Step 4: Review & Refine** (3 min)
- Show generated portrait visually
- Explain each dimension
- Allow manual adjustments
- Highlight low-confidence areas

**Step 5: Confirmation** (1 min)
- Save portrait
- Explain what happens next
- Offer to explore alignment immediately

---

## Portrait Visualization

### Primary View: Radar Chart

8-axis radar chart showing position on each dimension:
- Center = neutral
- Distance from center = intensity
- Color saturation = confidence

### Alternative View: Dimension Cards

List of 8 cards, each showing:
- Dimension name and definition
- Position indicator (slider-style)
- Intensity and confidence meters
- "Why we think this" explanation
- Edit button

### Comparison View

Side-by-side radar charts:
- User's portrait
- Political actor's portrait
- Overlay showing alignment/misalignment

---

## Portrait Refinement

### User-Initiated Refinement

Users can:
1. **Adjust position** on any dimension manually
2. **Retake questions** for specific dimension
3. **Add context** (e.g., "I care about this in economic policy but not social policy")
4. **Mark dimensions** as more/less important

### System-Initiated Refinement

System prompts refinement when:
1. **Low confidence** on key dimensions
2. **Contradictory answers** detected
3. **Significant time passed** (e.g., 6 months) - "Has your view on X changed?"
4. **Major political events** - "This event relates to your values on X. Want to refine?"

---

## Confidence Calculation

Confidence in each dimension is based on:

1. **Answer consistency**: Do multiple questions point to same position?
2. **Answer strength**: Did user choose "strongly" or "somewhat"?
3. **Question coverage**: Have we asked enough questions?
4. **Time stability**: Have answers been consistent over time?

**Formula** (simplified):
```
confidence = (consistency * 0.4) + (strength * 0.3) + (coverage * 0.2) + (stability * 0.1)
```

---

## Privacy & Data Handling

### Storage
- Value portraits stored encrypted
- No personally identifiable information required
- User can export or delete portrait at any time

### Usage
- Portrait used only for alignment calculation
- Never shared or sold
- Not used for advertising or profiling

---

## Advanced Features (Post-MVP)

### Contextual Values

**Concept**: Values may differ by context (economic vs social policy)

**Example**: User might favor authority in economic regulation but liberty in personal choices

**Implementation**:
- Add context tags to questions
- Calculate separate sub-portraits for different contexts
- Show context-specific alignment

### Value Importance Weighting

**Concept**: Not all dimensions matter equally to all users

**Implementation**:
- After initial portrait, ask: "Which of these values matter most to you?"
- User ranks or rates importance (1-5)
- Alignment calculation weights by importance

**Example**:
```
User cares deeply about environment (importance: 5)
User neutral on religious values (importance: 1)

Alignment calculation gives 5x weight to environmental alignment
```

### Value Stability Tracking

**Concept**: Track how user's values change over time

**Implementation**:
- Store portrait versions with timestamps
- Prompt periodic re-evaluation (every 6 months)
- Show "Your values over time" visualization
- Highlight significant shifts

**Use case**: "Your position on economic equality has shifted from -0.3 to +0.2 over the past year"

### Uncertainty Exploration

**Concept**: Help users explore dimensions where they're uncertain

**Implementation**:
- Identify low-confidence dimensions
- Offer educational content explaining the dimension
- Provide more nuanced questions
- Show how different positions would affect alignment

**Example**:
```
"You seem uncertain about Direct vs Representative Democracy.
Here's what this dimension means... [explanation]
Would you like to answer more questions about this?"
```

---

## Question Design Guidelines

### Principles

1. **Clear and Concrete**: Avoid abstract philosophical language
2. **Balanced**: Don't bias toward one pole
3. **Relevant**: Connect to real political decisions
4. **Diverse**: Mix question types to triangulate
5. **Accessible**: Understandable to average voter

### Question Writing Process

1. **Draft**: Write initial question
2. **Review**: Check for bias, clarity
3. **Test**: Pilot with 10-20 users
4. **Analyze**: Check if answers correlate with expected dimension
5. **Refine**: Adjust based on data
6. **Deploy**: Add to question pool

### Example Question Evolution

**Draft 1** (Too abstract):
"Do you believe in the primacy of individual autonomy?"

**Draft 2** (Better, but still academic):
"Should individual freedom be prioritized over collective welfare?"

**Final** (Concrete and relatable):
"If a new regulation would improve public safety but limit personal choices, should it be implemented?"

---

## Privacy & Ethics

### Data Minimization

- Collect only what's needed for value portrait
- No demographic data required (optional for research)
- No tracking of political browsing outside app

### User Control

- Export full data at any time
- Delete account and all data
- Opt out of any data usage
- Revise portrait without explanation

### Transparency

- Explain how each answer affects portrait
- Show all data used in calculations
- Publish methodology publicly
- Allow independent audits

### No Manipulation

- Never nudge users toward specific values
- No A/B testing that affects value calculations
- No personalized question ordering to influence outcomes
- No hidden scoring or profiling

---

**Next**: [04-political-actor-monitoring.md](./04-political-actor-monitoring.md) - How we track political actors
