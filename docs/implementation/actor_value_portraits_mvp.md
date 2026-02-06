# Actor Value Portraits MVP Implementation

## Overview

This document describes the implementation of the Actor Value Portraits MVP, which enables alignment calculations between users and political actors by storing actor positions on value dimensions in a proper database model instead of metadata.

## Implementation Date

February 2, 2026

## What Was Implemented

### 1. Database Schema

**Migration**: `db/migrate/20260202110742_create_actor_value_portraits.rb`

Created `actor_value_portraits` table with:
- `actor_id` (foreign key to actors)
- `value_dimension_id` (foreign key to value_dimensions)
- `position` (decimal, -100 to +100, required)
- `intensity` (decimal, 0-100, optional)
- `confidence` (decimal, 0-100, optional)
- Unique index on `[actor_id, value_dimension_id]`
- Index on `position` for performance

### 2. Models

**ActorValuePortrait** (`app/models/actor_value_portrait.rb`)
- Associations: `belongs_to :actor`, `belongs_to :value_dimension`
- Validations: position range (-100 to 100), intensity/confidence ranges (0-100)
- Scopes: `high_confidence`, `low_confidence`, `strong_position`, `moderate_position`
- Helper methods: `left_leaning?`, `right_leaning?`, `centrist?`, `strong?`, `moderate?`, `high_confidence?`, `low_confidence?`

**Updated Actor Model** (`app/models/actor.rb`)
- Added: `has_many :actor_value_portraits`
- Added: `has_many :value_dimensions, through: :actor_value_portraits`

**Updated ValueDimension Model** (`app/models/value_dimension.rb`)
- Added: `has_many :actor_value_portraits`
- Added: `has_many :actors, through: :actor_value_portraits`

### 3. Controller Updates

**ActorsController** (`app/controllers/actors_controller.rb`)

Updated `get_actor_positions` method to:
1. Query `ActorValuePortrait` records instead of metadata
2. Build hash of `dimension_id => position`

### 4. Seed Data

**Seed File**: `db/seeds/actors.rb`

Updated to create `ActorValuePortrait` records directly when seeding actors:
- Creates actor record without `value_positions` in metadata
- Immediately creates 8 `ActorValuePortrait` records for each actor
- Sets default intensity (70.0) and confidence (80.0) for MVP
- Eliminates need for separate data migration task

**Seed Results**:
- ✓ Created: 56 portraits (7 actors × 8 dimensions)
- All actors have complete value portraits on creation

### 5. Testing

**Factory**: `spec/factories/actor_value_portraits.rb`
- Base factory with random values
- Traits: `left_leaning`, `right_leaning`, `centrist`, `strong_position`, `moderate_position`, `high_confidence`, `low_confidence`, `high_intensity`, `low_intensity`

**Model Specs**: `spec/models/actor_value_portrait_spec.rb`
- 28 examples, 0 failures
- Tests for associations, validations, scopes, and instance methods

**Updated Specs**:
- `spec/models/actor_spec.rb`: Added association tests
- `spec/models/value_dimension_spec.rb`: Added association tests
- `spec/requests/actors_spec.rb`: All 15 examples pass

## Current Data

### Actors with Value Portraits

1. **Democratic Party** - 8 portraits
2. **Republican Party** - 8 portraits
3. **Joe Biden** - 8 portraits
4. **Donald Trump** - 8 portraits
5. **Kamala Harris** - 8 portraits
6. **Bernie Sanders** - 8 portraits
7. **Ron DeSantis** - 8 portraits

**Total**: 56 ActorValuePortrait records

### Value Dimensions Covered

All 8 core dimensions:
1. Individual Liberty vs Collective Authority
2. Economic Equality vs Free Markets
3. Tradition vs Progress
4. Nationalism vs Globalism
5. Security vs Privacy
6. Meritocracy vs Equity
7. Environmental Protection vs Economic Growth
8. Direct Democracy vs Representative Democracy

## What's NOT Implemented (Out of Scope for MVP)

As per requirements, the following are intentionally NOT implemented:
- Automated data collection from speeches/interventions
- NLP-based position extraction
- Change detection and monitoring
- Source tracking and weighting
- The full monitoring system from PRD 04

## How to Use

### Creating Actor Value Portraits

```ruby
actor = Actor.find_by(name: "Democratic Party")
dimension = ValueDimension.find_by(key: "liberty_authority")

portrait = ActorValuePortrait.create!(
  actor: actor,
  value_dimension: dimension,
  position: -30.0,
  intensity: 70.0,
  confidence: 80.0
)
```

### Querying Actor Positions

```ruby
actor = Actor.first
actor.actor_value_portraits.count # => 8
actor.value_dimensions.count # => 8

# Get specific dimension
liberty_dim = ValueDimension.find_by(key: "liberty_authority")
portrait = actor.actor_value_portraits.find_by(value_dimension: liberty_dim)
portrait.position # => -30.0
```

### Using in Controllers

The `ActorsController#get_actor_positions` method now automatically uses `ActorValuePortrait`:

```ruby
actor_positions = get_actor_positions(actor)
# Returns: { dimension_id => position, ... }
```

## Testing

Run all related tests:

```bash
# Model tests
bundle exec rspec spec/models/actor_value_portrait_spec.rb
bundle exec rspec spec/models/actor_spec.rb
bundle exec rspec spec/models/value_dimension_spec.rb

# Controller tests
bundle exec rspec spec/requests/actors_spec.rb
```

All tests pass successfully.

## Next Steps

Future enhancements (not part of this MVP):
1. Build automated monitoring system (PRD 04)
2. Add source tracking for positions
3. Implement change detection
4. Add NLP-based position extraction
5. Create admin interface for manual position updates
