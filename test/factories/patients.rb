FactoryBot.define do
  factory :patient do
    external_id { "MyString" }
    first_name { "MyString" }
    middle_name { "MyString" }
    last_name { "MyString" }
    date_of_birth { "2021-05-13" }
    gender { "MyString" }
    office_phone { "MyString" }
    cell_phone { "MyString" }
    email { "MyString" }
    street { "MyString" }
    street_2 { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zipcode { "MyString" }
  end
end
