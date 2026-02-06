FactoryBot.define do
  factory :actor do
    sequence(:name) { |n| "Actor #{n}" }
    actor_type { "personality" }
    country { "United States" }
    description { "A political actor" }
    active { true }

    trait :party do
      actor_type { "party" }
      sequence(:name) { |n| "Party #{n}" }
      program_url { "https://example.com/program" }
    end

    trait :personality do
      actor_type { "personality" }
      sequence(:name) { |n| "Politician #{n}" }
      role { "Senator" }
      party_affiliation { "Democratic Party" }
    end

    trait :organization do
      actor_type { "organization" }
      sequence(:name) { |n| "Organization #{n}" }
    end

    trait :with_image do
      image_url { "https://example.com/image.jpg" }
    end

    trait :with_program do
      program_url { "https://example.com/program" }
    end

    trait :inactive do
      active { false }
    end

    trait :democratic_party do
      name { "Democratic Party" }
      actor_type { "party" }
      country { "United States" }
      description { "One of the two major political parties in the United States" }
      image_url { "https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/DemocraticLogo.svg/200px-DemocraticLogo.svg.png" }
      program_url { "https://democrats.org/where-we-stand/party-platform/" }
    end

    trait :republican_party do
      name { "Republican Party" }
      actor_type { "party" }
      country { "United States" }
      description { "One of the two major political parties in the United States" }
      image_url { "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Republicanlogo.svg/200px-Republicanlogo.svg.png" }
      program_url { "https://www.gop.com/platform/" }
    end

    trait :joe_biden do
      name { "Joe Biden" }
      actor_type { "personality" }
      country { "United States" }
      role { "President of the United States" }
      party_affiliation { "Democratic Party" }
      description { "46th President of the United States" }
      image_url { "https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Joe_Biden_presidential_portrait.jpg/200px-Joe_Biden_presidential_portrait.jpg" }
    end
  end
end
