FactoryBot.define do
  factory :text_message do
    provider_id { "MyString" }
    direction { "outbound" }
    status { "ready" }
    body { "MyString" }
    error_code { "MyString" }
    number { "3038752721" }
    conference
  end
end
