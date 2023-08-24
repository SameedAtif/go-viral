FactoryBot.define do
  factory :gig do
    association :influencer, factory: [:user, :influencer]
    title { Faker::Book.title }
  end
end
