FactoryBot.define do
  factory :influencer do
    association :user, factory: [:user, :influencer]
    bio { Faker::Quote.famous_last_words }
    trait :reviewed do
      reviewed { true }
    end
  end
end
