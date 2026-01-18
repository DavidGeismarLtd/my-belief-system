# Module 1: Database Foundation - Part 2
## Questions Seed Data & Testing

This is a continuation of M1_DATABASE_FOUNDATION.md

---

## Questions Seed Data

### Sample Questions (3 per dimension = 24 total)

```ruby
# db/seeds/questions.rb

# Helper to create questions
def create_question(dimension_key, text, type, options, position, difficulty = 'medium')
  dimension = ValueDimension.find_by!(key: dimension_key)
  Question.find_or_create_by!(
    value_dimension: dimension,
    text: text,
    position: position
  ) do |q|
    q.question_type = type
    q.options = options
    q.difficulty = difficulty
  end
end

# 1. Liberty vs Authority (3 questions)
create_question(
  'liberty_authority',
  'Individual freedom should be prioritized over collective security.',
  'direct_value',
  { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
  1,
  'easy'
)

create_question(
  'liberty_authority',
  'Should the government have access to private communications to prevent terrorism?',
  'policy_preference',
  { options: ['Yes, security is more important', 'No, privacy is more important'] },
  2,
  'medium'
)

create_question(
  'liberty_authority',
  'A city wants to install surveillance cameras in all public spaces. How do you feel about this?',
  'tradeoff',
  { 
    slider: true, 
    left_label: 'Strongly oppose (privacy)', 
    right_label: 'Strongly support (safety)',
    min: 0,
    max: 100
  },
  3,
  'hard'
)

# 2. Economic Equality (3 questions)
create_question(
  'economic_equality',
  'Wealth should be distributed more equally across society.',
  'direct_value',
  { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
  1,
  'easy'
)

create_question(
  'economic_equality',
  'Should there be a maximum wage cap to reduce income inequality?',
  'policy_preference',
  { options: ['Yes, cap high incomes', 'No, let market decide'] },
  2,
  'medium'
)

create_question(
  'economic_equality',
  'A company CEO earns 300x the average worker. Which concerns you more?',
  'dilemma',
  { 
    option_a: 'The inequality is unfair to workers',
    option_b: 'Limiting CEO pay would hurt innovation'
  },
  3,
  'hard'
)

# 3. National Sovereignty (3 questions)
create_question(
  'national_sovereignty',
  'International cooperation is more important than national sovereignty.',
  'direct_value',
  { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
  1,
  'easy'
)

create_question(
  'national_sovereignty',
  'Should your country cede some decision-making power to international bodies like the UN?',
  'policy_preference',
  { options: ['Yes, for global cooperation', 'No, maintain full sovereignty'] },
  2,
  'medium'
)

create_question(
  'national_sovereignty',
  'An international climate agreement requires your country to limit economic growth. Your position?',
  'tradeoff',
  { 
    slider: true, 
    left_label: 'Reject (protect economy)', 
    right_label: 'Accept (global cooperation)',
    min: 0,
    max: 100
  },
  3,
  'hard'
)

# 4. Tradition vs Progress (3 questions)
create_question(
  'tradition_progress',
  'Society should embrace change rather than preserve traditions.',
  'direct_value',
  { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
  1,
  'easy'
)

create_question(
  'tradition_progress',
  'Should schools teach traditional values or focus on critical thinking and questioning norms?',
  'policy_preference',
  { options: ['Teach traditional values', 'Focus on critical thinking'] },
  2,
  'medium'
)

create_question(
  'tradition_progress',
  'A cultural tradition is being challenged as outdated. Which matters more?',
  'dilemma',
  { 
    option_a: 'Preserving cultural heritage',
    option_b: 'Adapting to modern values'
  },
  3,
  'hard'
)

# 5. Environment vs Growth (3 questions)
create_question(
  'environment_growth',
  'Environmental protection should take priority over economic growth.',
  'direct_value',
  { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
  1,
  'easy'
)

create_question(
  'environment_growth',
  'Should a factory that provides 1,000 jobs be shut down if it pollutes a local river?',
  'policy_preference',
  { options: ['Yes, shut it down', 'No, keep it open'] },
  2,
  'medium'
)

create_question(
  'environment_growth',
  'Your country can either grow GDP by 5% or reduce emissions by 30%. How do you prioritize?',
  'tradeoff',
  { 
    slider: true, 
    left_label: 'Prioritize emissions reduction', 
    right_label: 'Prioritize economic growth',
    min: 0,
    max: 100
  },
  3,
  'hard'
)

# 6. Direct vs Representative Democracy (3 questions)
create_question(
  'direct_representative',
  'Citizens should vote directly on major policy decisions rather than electing representatives.',
  'direct_value',
  { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
  1,
  'easy'
)

puts "✓ Created #{Question.count} questions across #{ValueDimension.count} dimensions"
```

---


