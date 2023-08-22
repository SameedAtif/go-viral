FactoryBot.define do
  factory :influencer do
    association :user, factory: [:user, :creator]
    bio { Faker::Quote.famous_last_words }
  end
end
