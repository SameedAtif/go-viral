FactoryBot.define do
  factory :gig_deliverable_review do
    gig_client
    client
    gig_deliverable
    remarks { Faker::Quote.famous_last_words }
    rating { rand(0.0..5.0) }
  end
end
