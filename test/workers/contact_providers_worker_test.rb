require "test_helper"

class ContactProvidersWorkerTest < ActiveSupport::TestCase
  setup do
    @odv_provider = OnDemandClient::Provider.new(1112.0, nil, nil, "Jonathan Hinds", "JH2572", "(420) 289-7729")
  end

  test "should create text messages" do
    conference = create(:conference)

    assert_difference "TextMessage.count" => 1, "Provider.count" => 1, "SendTextMessageWorker.jobs.count" => 1 do
      ContactProvidersWorker.new.perform(conference.id, [@odv_provider])
    end

    assert conference.reload

    assert_equal ["+14202897729"], conference.contestants

    text_message = TextMessage.order(created_at: :desc).first

    assert_equal conference.id, text_message.conference_id
    assert_equal "Please call #{conference.number_link}", text_message.body
    assert_equal "+14202897729", text_message.number
  end

  test "#get_contestants" do
    providers_to_attempt = Setting.get("providers_to_attempt", 2)

    provider1 = OnDemandClient::Provider.new(1113.0, nil, nil, "Jonathan Hinds", "JH2572", "(420) 289-7729")
    provider2 = OnDemandClient::Provider.new(1114.0, nil, nil, "Jonathan Hinds", "JH2572", "(420) 289-7729")

    contestants = ContactProvidersWorker.new.get_contestants([@odv_provider, provider1, provider2])
    assert_equal providers_to_attempt, contestants.count
    assert_contestants contestants

    contestants = ContactProvidersWorker.new.get_contestants([provider1, provider2])
    assert_equal providers_to_attempt, contestants.count
    assert_contestants contestants

    contestants = ContactProvidersWorker.new.get_contestants([provider2])
    assert_equal 1, contestants.count
    assert_contestants contestants
  end

  def assert_contestants contestants
    contestants.each do |contestant|
      assert_not_nil contestant
    end
    assert_equal contestants.count, contestants.uniq.count
  end
end
