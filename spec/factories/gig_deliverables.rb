FactoryBot.define do
  factory :gig_deliverable do
    gig_client
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
  end
end
