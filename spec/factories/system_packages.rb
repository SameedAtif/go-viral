FactoryBot.define do
  factory :system_package do
    entity_name {'client'}
    package_name {'custom'}
    package_description {Faker::Quote.famous_last_words}
    gross_price {rand(0.00..1000.00)}
    fee {rand(0.01..0.50)}
    discount {rand(0.01..0.10)}
    discount_expires_at {1.year.from_now}

    after(:build) do |system_package|
      system_package.system_package_resources << create(:system_package_resource, system_package: system_package)
    end
  end
end
