require "test_helper"

class SaveProviderTest < ActiveSupport::TestCase
  setup do
    @odv_provider = OnDemandClient::Provider.new(1112.0, nil, nil, "Jonathan Hinds", "JH2572", "(420) 289-7729")
  end

  test "#call" do
    assert_difference "Provider.count" do
      SaveProvider.new(@odv_provider).call
    end

    provider = Provider.order(created_at: :desc).first

    assert_equal "1112.0", provider.external_id
    assert_equal "Jonathan Hinds", provider.name
    assert_equal "JH2572", provider.phy_code
    assert_equal "+14202897729", provider.cell_phone

    assert_no_difference "Provider.count" do
      SaveProvider.new(@odv_provider).call
    end
  end
end
