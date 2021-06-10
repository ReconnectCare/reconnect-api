FactoryBot.define do
  factory :patient do
    external_id { "MyString" }
    first_name { "first" }
    middle_name { "m" }
    last_name { "last" }
    date_of_birth { "2021-05-13" }
    gender { "male" }
    office_phone { nil }
    cell_phone { "+13035550000" }
    email { "first@last.com" }
    street { "MyString" }
    street_2 { "MyString" }
    city { "MyString" }
    state { "CA" }
    zipcode { "89023" }
    odv_id { "1002.3" }
  end
end
