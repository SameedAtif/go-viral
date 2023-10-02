FactoryBot.define do
  factory :organization_system_package do
    organization
    system_package
    start_time {DateTime.current}
    end_time {1.year.from_now}

    after(:build) do |organization_system_package|
      organization_system_package.system_package.system_package_resources.each do |resource|
        organization_system_package.organization_system_package_resources << create(
          :organization_system_package_resource,
          organization_system_package: organization_system_package,
          system_package_resource: resource
        )
      end
    end
  end
end
