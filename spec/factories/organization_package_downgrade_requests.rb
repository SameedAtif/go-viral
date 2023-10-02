FactoryBot.define do
  factory :organization_package_downgrade_request do
    current_package { create(:system_package) }
    requested_package { create(:system_package) }
    refundable_amount { rand(0..100.00) }
    fee { rand(0.00..0.10) }
    reason { Faker::Quote.famous_last_words }
    status { OrganizationPackageDowngradeRequest::STATUS_TYPES_MAP[:pending_review] }
    resolved { false }
    organization
    reviewer
  end
end
