FactoryBot.define do
  factory :organization_detail do
    organization
    client
    trait :owner do
      client_role { 'Owner' }
    end
  end
end
