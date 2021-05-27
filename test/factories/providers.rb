FactoryBot.define do
  factory :provider do
    external_id { "my-provider-1" }
    name { "Provider 1" }
    phy_code { "CODE 1" }
    cell_phone { "+13038752721" }
  end
end
