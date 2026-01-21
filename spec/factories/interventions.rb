FactoryBot.define do
  factory :intervention do
    association :actor
    intervention_type { "tweet" }
    content { "This is a sample intervention content" }
    source_url { "https://twitter.com/example" }
    source_platform { "twitter" }
    published_at { 2.days.ago }
    active { true }

    trait :tweet do
      intervention_type { "tweet" }
      source_platform { "twitter" }
      source_url { "https://twitter.com/example" }
    end

    trait :video do
      intervention_type { "video" }
      source_platform { "youtube" }
      source_url { "https://youtube.com/watch?v=example" }
    end

    trait :speech do
      intervention_type { "speech" }
      source_platform { "press_release" }
      source_url { "https://example.com/speech" }
    end

    trait :declaration do
      intervention_type { "declaration" }
      source_platform { "press_release" }
      source_url { "https://example.com/declaration" }
    end

    trait :article do
      intervention_type { "article" }
      source_platform { "website" }
      source_url { "https://example.com/article" }
    end

    trait :interview do
      intervention_type { "interview" }
      source_platform { "website" }
      source_url { "https://example.com/interview" }
    end

    trait :recent do
      published_at { 1.day.ago }
    end

    trait :old do
      published_at { 6.months.ago }
    end

    trait :inactive do
      active { false }
    end
  end
end

