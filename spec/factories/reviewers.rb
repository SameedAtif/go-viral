FactoryBot.define do
  factory :reviewer do
    association :user, factory: [:user, :reviewer]
  end
end
