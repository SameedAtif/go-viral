FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    trait :client do
      user_roles { ['Client'] }
    end

    trait :creator do
      user_roles { ['Creator'] }
    end

    trait :admin do
      user_roles { ['Admin'] }
    end

    trait :admin do
      user_roles { ['Reviewer'] }
    end
  end
end
