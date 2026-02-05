FactoryBot.define do
  factory :user_value_portrait do
    association :user
    association :value_dimension
    position { rand(-100.0..100.0).round(2) }
    intensity { rand(0.0..100.0).round(2) }
    confidence { rand(0.0..100.0).round(2) }

    trait :strong_left do
      position { rand(-100.0..-50.0).round(2) }
    end

    trait :moderate_left do
      position { rand(-49.0..-20.0).round(2) }
    end

    trait :centrist do
      position { rand(-19.0..19.0).round(2) }
    end

    trait :moderate_right do
      position { rand(20.0..49.0).round(2) }
    end

    trait :strong_right do
      position { rand(50.0..100.0).round(2) }
    end

    trait :high_confidence do
      confidence { rand(70.0..100.0).round(2) }
    end

    trait :low_confidence do
      confidence { rand(0.0..49.0).round(2) }
    end

    trait :high_intensity do
      intensity { rand(70.0..100.0).round(2) }
    end

    trait :low_intensity do
      intensity { rand(0.0..49.0).round(2) }
    end
  end
end
