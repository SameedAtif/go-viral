FactoryBot.define do
  factory :organization_feedback do
    organization
    score { rand(0.0..5.0) }
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
  end
end
