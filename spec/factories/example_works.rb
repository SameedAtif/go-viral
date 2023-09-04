FactoryBot.define do
  factory :example_work do
    project
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
  end
end
