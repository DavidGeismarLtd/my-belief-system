FactoryBot.define do
  factory :user_answer do
    association :user
    association :question

    # Default to direct_value type answer
    answer_data do
      {
        value: rand(1..5),
        time_spent_seconds: rand(5..60)
      }
    end

    trait :direct_value do
      association :question, factory: [ :question, :direct_value ]
      answer_data do
        {
          value: rand(1..5),
          time_spent_seconds: rand(5..60)
        }
      end
    end

    trait :policy_preference do
      association :question, factory: [ :question, :policy_preference ]
      answer_data do
        {
          value: [ 'left', 'right' ].sample,
          time_spent_seconds: rand(5..60)
        }
      end
    end

    trait :tradeoff_slider do
      association :question, factory: [ :question, :tradeoff_slider ]
      answer_data do
        {
          value: rand(0..100),
          time_spent_seconds: rand(5..60)
        }
      end
    end

    trait :dilemma do
      association :question, factory: [ :question, :dilemma ]
      answer_data do
        {
          value: [ 'A', 'B' ].sample,
          time_spent_seconds: rand(5..60),
          reasoning: 'Test reasoning'
        }
      end
    end

    trait :quick_answer do
      answer_data do
        {
          value: 3,
          time_spent_seconds: 5
        }
      end
    end

    trait :slow_answer do
      answer_data do
        {
          value: 3,
          time_spent_seconds: 120
        }
      end
    end
  end
end
