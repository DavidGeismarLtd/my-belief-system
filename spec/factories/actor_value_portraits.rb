FactoryBot.define do
  factory :actor_value_portrait do
    association :actor
    association :value_dimension
    position { rand(-100.0..100.0).round(2) }
    intensity { rand(0.0..100.0).round(2) }
    confidence { rand(0.0..100.0).round(2) }

    trait :left_leaning do
      position { rand(-100.0..-20.0).round(2) }
    end

    trait :right_leaning do
      position { rand(20.0..100.0).round(2) }
    end

    trait :centrist do
      position { rand(-20.0..20.0).round(2) }
    end

    trait :strong_position do
      position { [ rand(-100.0..-50.0), rand(50.0..100.0) ].sample.round(2) }
    end

    trait :moderate_position do
      position { rand(-50.0..50.0).round(2) }
    end

    trait :high_confidence do
      confidence { rand(70.0..100.0).round(2) }
    end

    trait :low_confidence do
      confidence { rand(0.0..50.0).round(2) }
    end

    trait :high_intensity do
      intensity { rand(70.0..100.0).round(2) }
    end

    trait :low_intensity do
      intensity { rand(0.0..50.0).round(2) }
    end
  end
end

