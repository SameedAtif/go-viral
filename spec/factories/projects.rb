FactoryBot.define do
  factory :project do
    client
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
    budget { rand(0.00..1000.00) }
    start_time { DateTime.current}
    end_time { 1.month.from_now}
    required_number_of_influencers { rand(1..5)}
    status { 'draft' }
    payment_type { 'Cash' }
    target_audience { 'Gen-Z' }
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
