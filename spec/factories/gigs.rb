FactoryBot.define do
  factory :gig do
    influencer
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
    targeted_demographic_start_age { 10 }
    targeted_demographic_end_age { 15 }
    targeted_geographic_audience { ['Pakistan'] }
    views { rand(100..500) }
    trait :reviewed do
      reviewer
      reviewed { true }
    end
  end
end
