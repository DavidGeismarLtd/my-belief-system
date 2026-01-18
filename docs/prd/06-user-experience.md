# User Experience & Interface Design

## Design Philosophy

### Core Principles

1. **Calm, Not Reactive**
   - Muted color palette
   - Generous whitespace
   - No red/urgent styling except for critical issues
   - Smooth, deliberate animations

2. **Clarity Over Cleverness**
   - Plain language, no jargon
   - Obvious navigation
   - Consistent patterns
   - Progressive disclosure of complexity

3. **Trust Through Transparency**
   - Always show data sources
   - Explain calculations
   - Admit uncertainty
   - No hidden algorithms

4. **Respect User Time**
   - Fast load times
   - Efficient workflows
   - Smart defaults
   - Optional deep dives

---

## Visual Design System

### Color Palette

**Primary Colors** (Neutral, Non-Partisan):
- Background: `#FAFAFA` (off-white)
- Surface: `#FFFFFF` (white)
- Text Primary: `#1A1A1A` (near-black)
- Text Secondary: `#666666` (gray)
- Border: `#E0E0E0` (light gray)

**Accent Colors** (Functional, Not Political):
- Info: `#4A90E2` (blue)
- Success: `#7ED321` (green)
- Warning: `#F5A623` (amber)
- Error: `#D0021B` (red, used sparingly)

**Value Dimension Colors** (Distinct but Muted):
- Use color-blind friendly palette
- Consistent across all views
- Saturation indicates confidence

**Alignment Indicators**:
- Strong alignment (0.8-1.0): `#7ED321` (green)
- Moderate alignment (0.5-0.8): `#4A90E2` (blue)
- Weak alignment (0.3-0.5): `#F5A623` (amber)
- Misalignment (0.0-0.3): `#D0021B` (red)

### Typography

**Font Family**: 
- Primary: Inter or System UI
- Monospace (for data): SF Mono or Consolas

**Scale**:
- H1: 32px, Bold
- H2: 24px, Semibold
- H3: 20px, Semibold
- Body: 16px, Regular
- Small: 14px, Regular
- Caption: 12px, Regular

### Spacing

**Base unit**: 8px

**Scale**: 4px, 8px, 16px, 24px, 32px, 48px, 64px

---

## Information Architecture

### Primary Navigation

**Top-level sections**:

1. **Dashboard** - Overview of all alignments
2. **My Values** - User's value portrait
3. **Actors** - Browse and search political actors
4. **Timeline** - Historical view of changes
5. **Settings** - Preferences and account

### Navigation Pattern

**Desktop**: Persistent left sidebar
**Mobile**: Bottom tab bar + hamburger menu

---

## Key Screens & Flows

### 1. Onboarding Flow

#### Screen 1.1: Welcome
**Purpose**: Set expectations and build trust

**Content**:
- Hero: "Understand your political values"
- Subhead: "Build a clear portrait of what you believe, then see how political actors align with those values over time."
- Bullet points:
  - ✓ Takes 15-20 minutes
  - ✓ No right or wrong answers
  - ✓ You can refine anytime
  - ✓ Your data stays private
- CTA: "Get Started"
- Link: "Learn more about how this works"

---

#### Screen 1.2: Value Questions
**Purpose**: Gather data to build value portrait

**Layout**:
- Progress bar at top (e.g., "Question 8 of 24")
- Question text (large, centered)
- Answer options (buttons or slider)
- "Skip" option (bottom right)
- "Back" option (bottom left)

**Question Display**:
```
┌─────────────────────────────────────────────┐
│ Progress: ████████░░░░░░░░░░░░ 8/24         │
├─────────────────────────────────────────────┤
│                                              │
│  Should the government provide universal    │
│  healthcare, or should healthcare be        │
│  primarily private?                          │
│                                              │
│  ┌─────────────────────────────────────┐   │
│  │ Government-run universal healthcare │   │
│  └─────────────────────────────────────┘   │
│                                              │
│  ┌─────────────────────────────────────┐   │
│  │ Government option + private market  │   │
│  └─────────────────────────────────────┘   │
│                                              │
│  ┌─────────────────────────────────────┐   │
│  │ Primarily private healthcare        │   │
│  └─────────────────────────────────────┘   │
│                                              │
│  ┌─────────────────────────────────────┐   │
│  │ I'm not sure                        │   │
│  └─────────────────────────────────────┘   │
│                                              │
│                    [Skip]                    │
└─────────────────────────────────────────────┘
```

**Interaction**:
- Click answer → auto-advance to next question
- Smooth transition (fade or slide)
- Can go back to change answers

---

#### Screen 1.3: Portrait Review
**Purpose**: Show generated portrait and allow refinement

**Layout**:
- Header: "Your Value Portrait"
- Subhead: "Based on your answers, here's what you value politically"
- Radar chart (center, large)
- Dimension list (below or side)
- CTAs: "Looks good" / "Refine"

**Dimension List Item**:
```
┌─────────────────────────────────────────────┐
│ Individual Liberty vs Collective Authority  │
├─────────────────────────────────────────────┤
│ You lean toward: Individual Liberty         │
│                                              │
│ ●────────────○                              │
│ Liberty                        Authority    │
│                                              │
│ Strength: Strong (0.8)                      │
│ Confidence: High (0.85)                     │
│                                              │
│ Why we think this: You strongly agreed that │
│ personal freedom is more important than...  │
│                                              │
│ [Edit this dimension]                       │
└─────────────────────────────────────────────┘
```

---

### 2. Dashboard

#### Screen 2.1: Alignment Dashboard
**Purpose**: Overview of alignment with tracked actors

**Layout**:
- Header: "Your Alignment Dashboard"
- Filter/sort controls (top right)
- Actor cards (grid or list)
- Empty state: "Add actors to track"

**Actor Card**:
```
┌─────────────────────────────────────────────┐
│ [Photo] Senator Jane Smith                  │
│         Democratic Party • California       │
├─────────────────────────────────────────────┤
│ Overall Alignment: 0.72 (Strong) ✓          │
│                                              │
│ ████████████████░░░░ 72%                    │
│                                              │
│ Trend: ↓ Decreased 0.08 in last 30 days    │
│                                              │
│ Strong alignment on:                        │
│ • Environmental Protection                  │
│ • Economic Equality                         │
│                                              │
│ Weak alignment on:                          │
│ • National Sovereignty                      │
│                                              │
│ [View Details] [Stop Tracking]              │
│                                              │
│ Last updated: 2 hours ago                   │
└─────────────────────────────────────────────┘
```

---

### 3. Actor Detail View

#### Screen 3.1: Actor Profile
**Purpose**: Deep dive into specific actor's values and alignment

**Layout**:
- Header: Actor name, photo, role
- Tab navigation: Overview / Dimensions / Timeline / Evidence
- Comparison toggle: "Compare with my values"

**Overview Tab**:
- Overall alignment score (large)
- Radar chart comparison (user vs actor)
- Summary text
- Recent changes
- Quick stats

**Dimensions Tab**:
- List of all 8 dimensions
- Each shows alignment score, positions, explanation
- Expandable for evidence

**Timeline Tab**:
- Line chart of alignment over time
- Key events marked
- Filter by dimension

**Evidence Tab**:
- List of sources (votes, speeches, statements)
- Sorted by recency or relevance
- Links to originals
- Shows how each affects value portrait

---

### 4. My Values

#### Screen 4.1: Value Portrait Manager
**Purpose**: View and refine user's value portrait

**Layout**:
- Header: "My Value Portrait"
- Last updated timestamp
- Radar chart (large, interactive)
- Dimension list (detailed)
- CTA: "Refine Portrait"

**Actions**:
- Click dimension → edit that dimension
- "Retake all questions"
- "Adjust importance" (set which dimensions matter most)
- Export portrait (JSON or PDF)

---

### 5. Actor Browser

#### Screen 5.1: Browse Actors
**Purpose**: Discover and add actors to track

**Layout**:
- Search bar (top)
- Filters: Type (party/personality), Jurisdiction, Party affiliation
- Results grid/list
- Each result shows: Name, role, party, "Track" button

**Search**:
- Autocomplete
- Search by name, office, party
- Recent searches

---

## Responsive Design

### Breakpoints

- **Mobile**: < 640px
- **Tablet**: 640px - 1024px
- **Desktop**: > 1024px

### Mobile Adaptations

**Dashboard**:
- Actor cards stack vertically
- Simplified card layout (hide some details)
- Swipe gestures for navigation

**Value Portrait**:
- Radar chart scales down
- Dimension list becomes primary view
- Tap to expand details

**Onboarding**:
- Full-screen questions
- Larger touch targets
- Simplified progress indicator

---

## Interaction Patterns

### Loading States

**Initial load**: Skeleton screens (not spinners)
**Data refresh**: Subtle progress indicator in header
**Long operations**: Progress bar with estimated time

### Empty States

**No tracked actors**:
- Illustration
- "You're not tracking any actors yet"
- CTA: "Browse actors" or "Search for someone"

**No data available**:
- "We don't have enough data on [Actor] yet"
- Explanation of why
- "Check back soon" or "Suggest a source"

### Error States

**Network error**:
- "Can't connect right now"
- "Your data is saved. Try again when you're online."
- Retry button

**Data error**:
- "Something went wrong"
- Explanation (if available)
- "Report this issue" link

---

## Accessibility

### Requirements

- **WCAG 2.1 AA compliance**
- Keyboard navigation for all functions
- Screen reader support
- Color contrast ratios >4.5:1
- Focus indicators
- Alt text for all images
- Semantic HTML

### Specific Considerations

**Radar charts**: 
- Provide table view alternative
- Screen reader describes each dimension

**Color coding**:
- Never rely on color alone
- Use icons + text labels
- Patterns for color-blind users

**Forms**:
- Clear labels
- Error messages associated with fields
- Logical tab order

---

## Performance Targets

- **First Contentful Paint**: < 1.5s
- **Time to Interactive**: < 3.5s
- **Lighthouse Score**: > 90

---

**Next**: [07-data-architecture.md](./07-data-architecture.md) - Database and data models

