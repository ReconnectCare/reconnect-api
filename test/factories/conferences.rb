FactoryBot.define do
  factory :conference do
    sid { nil }
    start_time { "2021-05-13 15:16:30" }
    end_time { "2021-05-13 15:16:30" }
    conference_number
    patient
    provider { nil }
    reason { "Telehealth call" }

    trait :with_provider do
      provider
    end
  end
end
