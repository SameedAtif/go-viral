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
    trait :verified do
      verified { true }
    end
  end
end
