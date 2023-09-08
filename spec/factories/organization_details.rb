FactoryBot.define do
  factory :organization_detail do
    organization
    client
    trait :owner do
      client_role { OrganizationDetail::CLIENT_ROLES_MAP[:owner] }
    end
  end
end
