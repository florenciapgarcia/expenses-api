FactoryBot.define do
  factory :user do
    first_name { "Pebbles" }
    last_name { "Test" }
    email { "pebbs_test@test.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
