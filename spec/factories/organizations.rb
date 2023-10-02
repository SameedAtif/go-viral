FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    address_1 { Faker::Address.street_address }
    address_2 { "#{Faker::Address.city}, #{Faker::Address.state}, #{Faker::Address.country}"}
    city { Faker::Address.city }
    country { Faker::Address.country }
    phone_number { Faker::PhoneNumber.phone_number}
    website_url { Faker::Internet.domain_name }
    facebook_url { Faker::Internet.url(host: 'facebook.com') }
    instagram_url { Faker::Internet.url(host: 'instagram.com') }
    linkedin_url { Faker::Internet.url(host: 'linkedin.com') }
    youtube_url { Faker::Internet.url(host: 'youtube.com') }
    tiktok_url { Faker::Internet.url(host: 'tiktok.com') }
    payment_plan { 'basic' }
    trait :verified do
      verified { true }
    end
    after(:build) do |organization|
      basic_client_package = SystemPackage.create!(
        entity_name: SystemPackage::ENTITY_NAME_TYPES[:client],
        package_name: 'Basic',
        package_description: "Get a feel of the bazaar.",
        discount: 0,
        gross_price: 0,
        fee: 0
      )
      SystemPackageResource.create!(
        system_package: basic_client_package,
        category: SystemPackageResource::CATEGORY_TYPES[:free],
        resource_name: SystemPackageResource::RESOURCE_NAME_TYPES[:number_of_projects],
        resource_value: SystemPackageResource::BASIC_RESOURCE_VALUE_MAP[:project],
        gross_price: 0,
        fee: 0,
        discount: 0
      )
      SystemPackageResource.create!(
        system_package: basic_client_package,
        category: SystemPackageResource::CATEGORY_TYPES[:free],
        resource_name: SystemPackageResource::RESOURCE_NAME_TYPES[:number_of_influencers],
        resource_value: SystemPackageResource::BASIC_RESOURCE_VALUE_MAP[:influencer],
        gross_price: 0,
        fee: 0,
        discount: 0
      )

      create(:organization_system_package, organization: organization, system_package: basic_client_package)
    end
  end
end
