FactoryBot.define do
  factory :gig_category do
    gig
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
    price { rand(0.00..100.00) }
  end
end
