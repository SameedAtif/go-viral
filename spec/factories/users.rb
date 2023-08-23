FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    confirmed_at { DateTime.current }

    trait :client do
      after(:build) do |instance|
        instance.user_roles << 'client'
      end
    end

    trait :creator do
      after(:build) do |instance|
        instance.user_roles << 'creator'
      end
    end

    trait :admin do
      after(:build) do |instance|
        instance.user_roles << 'admin'
      end
    end

    trait :reviewer do
      after(:build) do |instance|
        instance.user_roles << 'reviewer'
      end
    end
  end
end
