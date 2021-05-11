FactoryBot.define do
  factory :user do
    first_name { "Dusty" }
    last_name  { "Candland" }
    sequence(:email) { |n| "user_#{n}@testing.com" }
    password { "testing" }
    password_confirmation { "testing" }
    confirmed_at { Time.zone.now }
    roles { [:user] }
  end
end
