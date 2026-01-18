FactoryBot.define do
  factory :value_dimension do
    sequence(:key) { |n| "test_dimension_#{('a'..'z').to_a[n % 26]}" }
    sequence(:name) { |n| "Value Dimension #{n}" }
    left_pole { "Left Pole" }
    right_pole { "Right Pole" }
    sequence(:position) { |n| n }
    active { true }
    description { "A test value dimension" }

    trait :inactive do
      active { false }
    end

    trait :with_questions do
      after(:create) do |dimension|
        create_list(:question, 3, value_dimension: dimension)
      end
    end

    trait :with_portraits do
      after(:create) do |dimension|
        create_list(:user_value_portrait, 3, value_dimension: dimension)
      end
    end

    # Specific dimensions
    trait :liberty_authority do
      key { 'liberty_authority' }
      name { 'Individual Liberty vs. Authority' }
      left_pole { 'Individual Liberty' }
      right_pole { 'Collective Authority' }
    end

    trait :economic_equality do
      key { 'economic_equality' }
      name { 'Economic Equality vs. Free Market' }
      left_pole { 'Economic Equality' }
      right_pole { 'Free Market' }
    end
  end
end
