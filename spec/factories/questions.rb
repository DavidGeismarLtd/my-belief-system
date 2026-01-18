FactoryBot.define do
  factory :question do
    association :value_dimension
    text { "Do you agree with this statement?" }
    question_type { 'direct_value' }
    options do
      {
        scale: 5,
        labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree']
      }
    end
    sequence(:position)
    difficulty_score { 2 }
    active { true }

    trait :inactive do
      active { false }
    end

    trait :easy do
      difficulty_score { 1 }
    end

    trait :medium do
      difficulty_score { 3 }
    end

    trait :hard do
      difficulty_score { 5 }
    end

    trait :direct_value do
      question_type { 'direct_value' }
      options do
        {
          scale: 5,
          labels: ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree']
        }
      end
    end

    trait :policy_preference do
      question_type { 'policy_preference' }
      options do
        {
          left_option: 'Policy A',
          right_option: 'Policy B'
        }
      end
    end

    trait :tradeoff_slider do
      question_type { 'tradeoff_slider' }
      options do
        {
          left_label: 'More Freedom',
          right_label: 'More Security',
          scale: 100
        }
      end
    end

    trait :dilemma do
      question_type { 'dilemma' }
      options do
        {
          option_a: 'Choice A',
          option_b: 'Choice B'
        }
      end
    end

    trait :with_answers do
      after(:create) do |question|
        create_list(:user_answer, 3, question: question)
      end
    end
  end
end

