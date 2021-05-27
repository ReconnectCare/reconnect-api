FactoryBot.define do
  factory :voice_call do
    provider_id { "my_provider_id" }
    conference
    direction { "inbound" }
    status { "in_progress" }
    number { "+13035551111" }
  end
end
