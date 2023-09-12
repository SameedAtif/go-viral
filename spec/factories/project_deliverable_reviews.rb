FactoryBot.define do
  factory :project_deliverable_review do
    project_deliverable
    client
    project
    achieved_reach { rand(0..1000) }
    achieved_conversion { rand(0..1000) }
    remarks { Faker::Quote.famous_last_words }
    rating { rand(0.0..5.0) }
  end
end
