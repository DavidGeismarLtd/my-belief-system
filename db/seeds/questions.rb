# Questions Seed Data
# 24 universal onboarding questions across 8 dimensions (3 per dimension)
# These questions apply to all countries

puts "  Creating universal questions..."

# Clear existing questions
Question.destroy_all

# Helper to find dimension by key
def find_dimension(key)
  ValueDimension.find_by!(key: key)
end

questions = [
  # Liberty vs Authority (3 questions)
  {
    dimension: 'liberty_authority',
    text: 'Individual freedom should be prioritized over collective security.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 1,
    difficulty_score: 1
  },
  {
    dimension: 'liberty_authority',
    text: 'The government should have the authority to restrict certain freedoms to maintain social order.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 2,
    difficulty_score: 2
  },
  {
    dimension: 'liberty_authority',
    text: 'In a crisis, would you prefer: A) Temporary restrictions on freedoms for public safety, or B) Maintaining all freedoms regardless of risk?',
    question_type: 'dilemma',
    options: { option_a: 'Temporary restrictions', option_b: 'Maintain freedoms' },
    position: 3,
    difficulty_score: 3
  },

  # Economic Equality vs Free Markets (3 questions)
  {
    dimension: 'economic_equality',
    text: 'The government should redistribute wealth to reduce economic inequality.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 4,
    difficulty_score: 1
  },
  {
    dimension: 'economic_equality',
    text: 'Free markets, with minimal regulation, are the best way to create prosperity.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 5,
    difficulty_score: 2
  },
  {
    dimension: 'economic_equality',
    text: 'Where should the priority be: wealth redistribution or market freedom?',
    question_type: 'tradeoff_slider',
    options: { left_label: 'Wealth Redistribution', right_label: 'Market Freedom', min: 0, max: 100 },
    position: 6,
    difficulty_score: 2
  },

  # Tradition vs Progress (3 questions)
  {
    dimension: 'tradition_progress',
    text: 'Society should preserve traditional values and institutions.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 7,
    difficulty_score: 1
  },
  {
    dimension: 'tradition_progress',
    text: 'Rapid social change is necessary to address modern challenges.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 8,
    difficulty_score: 2
  },
  {
    dimension: 'tradition_progress',
    text: 'When a traditional practice conflicts with modern values, which should take priority?',
    question_type: 'policy_preference',
    options: { left: 'Preserve tradition', right: 'Adopt modern values' },
    position: 9,
    difficulty_score: 3
  },

  # Nationalism vs Globalism (3 questions)
  {
    dimension: 'nationalism_globalism',
    text: 'National interests should always come before international cooperation.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 10,
    difficulty_score: 1
  },
  {
    dimension: 'nationalism_globalism',
    text: 'International organizations should have more power to address global challenges.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 11,
    difficulty_score: 2
  },
  {
    dimension: 'nationalism_globalism',
    text: 'Where should the priority be: national sovereignty or global cooperation?',
    question_type: 'tradeoff_slider',
    options: { left_label: 'National Sovereignty', right_label: 'Global Cooperation', min: 0, max: 100 },
    position: 12,
    difficulty_score: 2
  },

  # Security vs Privacy (3 questions)
  {
    dimension: 'security_privacy',
    text: 'Government surveillance is acceptable if it prevents terrorism.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 13,
    difficulty_score: 1
  },
  {
    dimension: 'security_privacy',
    text: 'Personal privacy should never be compromised, even for security reasons.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 14,
    difficulty_score: 2
  },
  {
    dimension: 'security_privacy',
    text: 'After a major security threat, would you prefer: A) Increased surveillance and security measures, or B) Maintaining current privacy protections?',
    question_type: 'dilemma',
    options: { option_a: 'Increased surveillance', option_b: 'Maintain privacy' },
    position: 15,
    difficulty_score: 3
  },

  # Meritocracy vs Equity (3 questions)
  {
    dimension: 'meritocracy_equity',
    text: 'Success should be based purely on individual merit and effort.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 16,
    difficulty_score: 1
  },
  {
    dimension: 'meritocracy_equity',
    text: 'Society should actively work to correct historical inequalities.',
    question_type: 'direct_value',
    options: { scale: 5, labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'] },
    position: 17,
    difficulty_score: 2
  },
  {
    dimension: 'meritocracy_equity',
    text: 'Where should the priority be: rewarding merit or ensuring equity?',
    question_type: 'tradeoff_slider',
    options: { left_label: 'Reward Merit', right_label: 'Ensure Equity', min: 0, max: 100 },
    position: 18,
    difficulty_score: 2
  }
]

questions.each do |q_data|
  dimension = find_dimension(q_data.delete(:dimension))
  Question.create!(
    value_dimension: dimension,
    text: q_data[:text],
    question_type: q_data[:question_type],
    options: q_data[:options],
    position: q_data[:position],
    difficulty_score: q_data[:difficulty_score],
    country: nil,
    is_universal: true,
    active: true
  )
end

puts "    ✓ Created #{questions.count} universal questions"

puts "  ✅ Created #{Question.count} questions"
