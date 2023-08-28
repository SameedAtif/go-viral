FactoryBot.define do
  factory :client do
    association :user, factory: [:user, :client]
  end
end
