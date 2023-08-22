FactoryBot.define do
  factory :gig do
    association :influencer, factory: [:user, :creator]
    title { Faker::Book.title }
  end
end
