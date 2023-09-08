FactoryBot.define do
  factory :project do
    organization
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
    budget { rand(0.00..1000.00) }
    start_time { 1.day.from_now }
    end_time { 1.month.from_now}
    required_number_of_influencers { rand(1..5)}
    status { Project::STATUSES_MAP[:pending_review] }
    payment_type { Project::PAYMENT_TYPES_MAP[:cash] }
    targeted_demographic_start_age { 10 }
    targeted_demographic_end_age { 15 }
    targeted_geographic_audience { ['Pakistan'] }
    views { rand(100..500) }
    trait :reviewed do
      reviewed { true }
    end
    trait :payment_verified do
      payment_verified { true }
    end
    trait :is_draft do
      is_draft { true }
    end
  end
end
