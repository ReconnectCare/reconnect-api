FactoryBot.define do
  factory :setting do
    sequence(:name) { |n| "my_setting_#{n}" }
    value { "MyString" }
    value_type { "string" }
  end
end
