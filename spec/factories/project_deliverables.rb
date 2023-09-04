FactoryBot.define do
  factory :project_deliverable do
    project_milestone
    influencer
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
  end
end
