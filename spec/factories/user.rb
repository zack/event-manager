FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email_address { Faker::Internet.email }
    email_confirmation_code { SecureRandom.hex }
    uuid { SecureRandom.uuid }
    admin_confirmed { false }
    email_confirmed { false }

    factory :email_confirmed_user do
      email_confirmed { true }
      email_confirmation_code { nil }
    end

    factory :admin_confirmed_user do
      admin_confirmed { true }
      email_confirmation_code { nil }
    end

    factory :confirmed_user do
      admin_confirmed { true }
      email_confirmed { true }
      email_confirmation_code { nil }
    end
  end
end
