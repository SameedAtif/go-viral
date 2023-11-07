FactoryBot.define do
  factory :system_package_resource do
    system_package
    category { 'paid' }
    resource_name {'number_of_projects'}
    resource_value {'10'}
    gross_price {100.00}
    fee {10.00}
    discount {0.00}
    discount_expires_at {1.year.from_now}
  end
end
