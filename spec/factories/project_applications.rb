FactoryBot.define do
  factory :project_application do
    project
    influencer
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
    status { 'submitted' }
    budget { rand(0.00..100.00) }
    delivery_date { 15.days.from_now }
  end
end
