FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { "Test User" }
    country { "United States" }
    password { "password123" }
    password_confirmation { "password123" }
    onboarding_completed { false }
    onboarding_progress { 0 }
    skipped_questions { [] }

    trait :onboarding_completed do
      onboarding_completed { true }
      onboarding_progress { 100 }
    end

    trait :with_answers do
      after(:create) do |user|
        create_list(:user_answer, 3, user: user)
      end
    end

    trait :with_portraits do
      after(:create) do |user|
        create_list(:user_value_portrait, 3, user: user)
      end
    end
  end
end
