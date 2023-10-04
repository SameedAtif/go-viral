FactoryBot.define do
  factory :gig_package do
    gig
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
    price { rand(0.00..100.00) }
    delivery_estimation { rand(1..10) }
    review_limit { rand(1..10) }
    features {["Shot-out", "Video"]}
  end
end
