# Alignment Engine

## Overview

The **Alignment Engine** compares user value portraits with political actor value portraits to calculate and present alignment in a nuanced, explainable way.

## Core Principles

1. **Alignment is multidimensional** - Not a single score
2. **Uncertainty is visible** - Low confidence is surfaced
3. **Context matters** - Explain why alignment exists or doesn't
4. **Change is tracked** - Show how alignment evolves over time
5. **No recommendations** - Present data, don't prescribe action

---

## Alignment Calculation

### Dimension-Level Alignment

For each value dimension, calculate alignment between user and actor:

**Formula**:
```
dimension_alignment = 1 - (|user_position - actor_position| / 2)

Where:
- user_position: Float (-1 to +1)
- actor_position: Float (-1 to +1)
- dimension_alignment: Float (0 to 1)
  - 1.0 = perfect alignment
  - 0.5 = neutral (positions are opposite)
  - 0.0 = maximum misalignment
```

**Example**:
- User position: -0.6 (leans liberty)
- Actor position: -0.4 (leans liberty, but less strongly)
- Alignment: 1 - (|-0.6 - (-0.4)| / 2) = 1 - (0.2 / 2) = 0.9 (strong alignment)

---

### Weighted Alignment

Account for user's intensity (how much they care) and confidence:

**Formula**:
```
weighted_alignment = dimension_alignment * user_intensity * min(user_confidence, actor_confidence)

Where:
- user_intensity: How strongly user holds this value (0-1)
- user_confidence: How certain we are of user's position (0-1)
- actor_confidence: How certain we are of actor's position (0-1)
```

**Rationale**:
- If user doesn't care much about a dimension (low intensity), alignment matters less
- If we're uncertain about either position (low confidence), alignment is less meaningful

---

### Overall Alignment Score

Aggregate across all dimensions:

**Formula**:
```
overall_alignment = Σ(weighted_alignment_i) / Σ(user_intensity_i)

Where:
- i = each dimension
- Sum of weighted alignments divided by sum of intensities (normalizes for what user cares about)
```

**Result**: Float (0-1) representing overall alignment

**Interpretation**:
- 0.9-1.0: Very strong alignment
- 0.7-0.9: Strong alignment
- 0.5-0.7: Moderate alignment
- 0.3-0.5: Weak alignment
- 0.0-0.3: Misalignment

---

## Alignment Presentation

### Alignment Dashboard

**Primary View**: List of tracked actors with alignment scores

**Components**:

1. **Actor Card**
   - Actor name and photo
   - Overall alignment score (0-1)
   - Alignment trend (↑ increasing, ↓ decreasing, → stable)
   - Last updated timestamp
   - Quick action: "View details"

2. **Sorting Options**
   - By alignment (highest first)
   - By recent change (biggest changes first)
   - By actor type (parties, then personalities)
   - Alphabetical

3. **Filtering Options**
   - Actor type (parties / personalities / both)
   - Jurisdiction (federal / state / local)
   - Alignment threshold (e.g., only show >0.7)
   - Active in upcoming election

---

### Detailed Alignment View

**For a specific user-actor pair**:

**Section 1: Overview**
- Overall alignment score with visual indicator
- Trend over time (line chart)
- Summary statement: "You align strongly with [Actor] on 6 of 8 dimensions, particularly on environmental protection and economic equality."

**Section 2: Dimension Breakdown**
- Table or card list showing each dimension:
  - Dimension name
  - User position (visual indicator)
  - Actor position (visual indicator)
  - Alignment score
  - Confidence level
  - "Why" explanation

**Example Dimension Card**:
```
┌─────────────────────────────────────────────┐
│ Environmental Protection vs Economic Growth │
├─────────────────────────────────────────────┤
│ Your position:    ●────────────○            │
│                   (Strong protection)        │
│                                              │
│ [Actor] position: ●──────────○              │
│                   (Moderate protection)      │
│                                              │
│ Alignment: 0.85 (Strong) ✓                  │
│ Confidence: 0.78 (High)                     │
│                                              │
│ Why: [Actor] has consistently voted for     │
│ climate legislation and supports carbon     │
│ pricing, aligning with your strong          │
│ environmental values.                        │
│                                              │
│ [View evidence] [See changes over time]     │
└─────────────────────────────────────────────┘
```

**Section 3: Changes Over Time**
- Timeline showing how alignment has changed
- Key events that caused changes
- Dimension-specific timelines

**Section 4: Areas of Misalignment**
- Highlighted dimensions where alignment is low
- Explanation of differences
- Evidence for actor's position

**Section 5: Contradictions & Uncertainties**
- Flagged inconsistencies in actor's positions
- Low-confidence dimensions
- Alternative interpretations

---

## Comparison View

**Compare multiple actors side-by-side**:

**Layout**: Table or card grid

**Columns**:
- Actor name
- Overall alignment
- Dimension-by-dimension alignment
- Key differences

**Use cases**:
- Compare candidates in an election
- Compare parties
- Compare current vs historical alignment

**Example**:
```
┌──────────────┬──────────┬──────────┬──────────┐
│ Dimension    │ You      │ Actor A  │ Actor B  │
├──────────────┼──────────┼──────────┼──────────┤
│ Liberty vs   │ ●────○   │ ●──────○ │ ○────●   │
│ Authority    │ (-0.6)   │ (-0.4)   │ (+0.5)   │
│              │          │ 0.9 ✓    │ 0.45 ⚠   │
├──────────────┼──────────┼──────────┼──────────┤
│ Economic     │ ●──────○ │ ●────○   │ ○──────● │
│ Equality     │ (-0.4)   │ (-0.6)   │ (+0.7)   │
│              │          │ 0.9 ✓    │ 0.35 ✗   │
└──────────────┴──────────┴──────────┴──────────┘
```

---

## Change Detection & Alerts

### Types of Alignment Changes

1. **Drift**: Gradual change in alignment over time
   - Example: Alignment decreases from 0.8 to 0.6 over 6 months

2. **Sudden Shift**: Rapid change due to specific event
   - Example: Actor reverses position on key issue, alignment drops from 0.7 to 0.4

3. **Convergence**: Alignment increasing over time
   - Example: Actor adopts positions closer to user's values

4. **Divergence**: Alignment decreasing over time
   - Example: Actor moves away from user's values

### Alert Triggers

**Significant Change Threshold**: 
- Alignment change >0.15 in 30 days
- Alignment change >0.25 in 90 days
- Any dimension change >0.3

**Alert Content**:
- What changed (dimension and magnitude)
- Why it changed (specific statement/action)
- Impact on overall alignment
- Link to evidence

**Example Alert**:
```
⚠ Significant Change Detected

Senator Smith's alignment with your values decreased from 0.72 to 0.58

What changed:
- Economic Equality dimension: -0.4 shift
- Voted for tax cuts benefiting high earners
- Contradicts previous support for progressive taxation

This represents a major shift on a dimension you care strongly about.

[View details] [Update tracking preferences]
```

---

## Explanation System

### "Why" Explanations

For every alignment score, provide human-readable explanation:

**Template**:
```
You [align strongly/moderately/weakly] with [Actor] on [Dimension] because:

- [Actor] has [voted for/stated support for/implemented] [specific policy]
- This [aligns with/contradicts] your position that [user's value]
- Evidence: [link to source]

However, note that:
- [Any caveats, contradictions, or uncertainties]
```

**Example**:
```
You align strongly (0.88) with Senator Johnson on Environmental Protection because:

- Senator Johnson voted for the Clean Energy Act (2025)
- Sponsored legislation to ban single-use plastics
- Publicly stated: "Climate change is the defining challenge of our generation"
- This aligns with your strong support for environmental regulation

However, note that:
- Senator Johnson also supported a highway expansion project that environmental groups opposed
- This creates some tension with their stated environmental priorities
```

---

## Uncertainty Handling

### Low Confidence Scenarios

**When confidence is low (<0.5)**:

1. **Visual indicator**: Dotted lines, muted colors, "?" icon
2. **Explicit statement**: "We're uncertain about this alignment because..."
3. **Explanation of why**: 
   - "Limited data on [Actor]'s position"
   - "Contradictory statements from [Actor]"
   - "Your position on this dimension is unclear"
4. **Action**: "Answer more questions to improve confidence"

**Example**:
```
┌─────────────────────────────────────────────┐
│ Direct vs Representative Democracy          │
├─────────────────────────────────────────────┤
│ Alignment: 0.65 (Moderate) ?                │
│ Confidence: 0.42 (Low) ⚠                    │
│                                              │
│ We're uncertain about this alignment because:│
│ - Limited data on Senator Smith's views on  │
│   democratic processes                       │
│ - No recent votes or statements on this topic│
│                                              │
│ [Help improve this by answering questions]  │
└─────────────────────────────────────────────┘
```

---

## Data Model

### Alignment Entity
```
Alignment {
  id: UUID
  user_id: UUID
  actor_id: UUID
  calculated_at: DateTime
  
  overall_score: Float (0-1)
  overall_confidence: Float (0-1)
  
  dimensions: [
    {
      dimension_id: String
      user_position: Float
      actor_position: Float
      alignment_score: Float
      weighted_score: Float
      confidence: Float
    }
  ]
  
  changes: [
    {
      timestamp: DateTime
      dimension_id: String
      old_score: Float
      new_score: Float
      trigger_source_id: UUID
    }
  ]
}
```

---

**Next**: [06-user-experience.md](./06-user-experience.md) - Detailed UI/UX specifications

