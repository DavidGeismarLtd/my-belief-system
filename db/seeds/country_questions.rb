puts "  Creating country-specific questions..."

# Helper to find dimension by key
def find_dimension(key)
  ValueDimension.find_by!(key: key)
end

# ============================================================================
# UNITED STATES - SPECIFIC QUESTIONS
# ============================================================================

us_questions = [
  # Healthcare - US specific
  {
    dimension: 'economic_equality',
    text: 'Should the United States adopt a Medicare for All single-payer healthcare system?',
    question_type: 'policy_preference',
    options: {
      choices: [
        'Yes, single-payer for all',
        'Public option alongside private insurance',
        'Keep current system with improvements',
        'More private market competition',
        'Not sure'
      ]
    },
    position: 100,
    difficulty_score: 2,
    country: 'United States',
    is_universal: false
  },

  # Gun Rights - US specific
  {
    dimension: 'liberty_authority',
    text: 'How should the Second Amendment right to bear arms be interpreted?',
    question_type: 'policy_preference',
    options: {
      choices: [
        'Strict gun control with limited ownership',
        'Background checks and some restrictions',
        'Current regulations are appropriate',
        'Fewer restrictions on gun ownership',
        'Minimal to no gun regulations',
        'Not sure'
      ]
    },
    position: 101,
    difficulty_score: 3,
    country: 'United States',
    is_universal: false
  },

  # Immigration - US specific
  {
    dimension: 'nationalism_globalism',
    text: 'What should be done about the estimated 11 million undocumented immigrants in the United States?',
    question_type: 'policy_preference',
    options: {
      choices: [
        'Path to citizenship for all',
        'Path to citizenship for DACA recipients only',
        'Temporary work permits, no citizenship',
        'Deportation with exceptions',
        'Full deportation enforcement',
        'Not sure'
      ]
    },
    position: 102,
    difficulty_score: 3,
    country: 'United States',
    is_universal: false
  },

  # Abortion - US specific (post-Roe)
  {
    dimension: 'tradition_progress',
    text: 'After the Supreme Court overturned Roe v. Wade, how should abortion be regulated?',
    question_type: 'policy_preference',
    options: {
      choices: [
        'Legal nationwide with no restrictions',
        'Legal with some restrictions (e.g., after viability)',
        'Leave it to each state to decide',
        'Banned except for rape, incest, or health',
        'Banned in all circumstances',
        'Not sure'
      ]
    },
    position: 103,
    difficulty_score: 4,
    country: 'United States',
    is_universal: false
  },

  # Electoral College - US specific
  {
    dimension: 'direct_representative',
    text: 'Should the United States keep or abolish the Electoral College?',
    question_type: 'policy_preference',
    options: {
      choices: [
        'Abolish it, use national popular vote',
        'Reform it but keep the system',
        'Keep it as is',
        'Not sure'
      ]
    },
    position: 104,
    difficulty_score: 2,
    country: 'United States',
    is_universal: false
  },

  # Police Reform - US specific
  {
    dimension: 'liberty_authority',
    text: 'What approach should the U.S. take regarding police reform?',
    question_type: 'policy_preference',
    options: {
      choices: [
        'Defund police, invest in community programs',
        'Significant reforms (end qualified immunity, etc.)',
        'Moderate reforms (better training, oversight)',
        'Minor adjustments to current system',
        'Increase police funding and support',
        'Not sure'
      ]
    },
    position: 105,
    difficulty_score: 3,
    country: 'United States',
    is_universal: false
  },

  # Student Debt - US specific
  {
    dimension: 'economic_equality',
    text: 'Should the federal government cancel student loan debt?',
    question_type: 'policy_preference',
    options: {
      choices: [
        'Cancel all student debt',
        'Cancel debt up to $50,000 per person',
        'Cancel debt up to $10,000 per person',
        'Income-based forgiveness only',
        'No cancellation, personal responsibility',
        'Not sure'
      ]
    },
    position: 106,
    difficulty_score: 2,
    country: 'United States',
    is_universal: false
  }
]

# Create US-specific questions
us_questions.each do |q_data|
  dimension = find_dimension(q_data[:dimension])
  Question.create!(
    value_dimension: dimension,
    text: q_data[:text],
    question_type: q_data[:question_type],
    options: q_data[:options],
    position: q_data[:position],
    difficulty_score: q_data[:difficulty_score],
    country: q_data[:country],
    is_universal: q_data[:is_universal],
    active: true
  )
end

puts "    ✓ Created #{us_questions.count} US-specific questions"
