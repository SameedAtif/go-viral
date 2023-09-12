FactoryBot.define do
  factory :project_milestone do
    project
    title { Faker::Book.title }
    description { Faker::Quote.famous_last_words }
    reach { rand(1..10000)}
    conversion { rand(1..1000) }
    budget { rand(1.00..100.00) }
    start_time { project.start_time }
    end_time { 2.days.from_now }
  end
end
