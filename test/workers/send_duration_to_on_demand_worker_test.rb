require "test_helper"

class SendDurationToOnDemandWorkerTest < ActiveSupport::TestCase
  setup do
    @conference = create(:conference, :with_provider, status: :completed, end_time: DateTime.now)
  end

  test "perform" do
    mock = Minitest::Mock.new
    mock.expect :send_duration, 1, [OnDemandClient::Duration]

    OnDemandClient.stub :new, mock do
      SendDurationToOnDemandWorker.new.perform(@conference.id)
    end

    assert_mock mock

    # TODO Assert call was successful
  end
end
