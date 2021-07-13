FactoryBot.define do
  factory :request_log do
    sequence(:id) { |n| "request-log-id-#{n}" }
    verb { "MyString" }
    uri { "MyString" }
    request_headers { "" }
    request_body { "MyString" }
    status { "MyString" }
    response_headers { "" }
    response_body { "MyString" }
  end
end
