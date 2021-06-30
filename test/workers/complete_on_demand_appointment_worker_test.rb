require "test_helper"

class CompleteOnDemandAppointmentWorkerTest < ActiveSupport::TestCase
  setup do
    @conference = create(:conference, :with_provider, start_time: DateTime.new.utc, joined_time: DateTime.new.utc, end_time: DateTime.new.utc)
  end

  test "perform" do
    mock = Minitest::Mock.new
    mock.expect :schedule_appointment, 1, [OnDemandClient::CompletedVisit]

    OnDemandClient.stub :new, mock do
      CompleteOnDemandAppointmentWorker.new.perform(@conference.id)
    end

    assert_mock mock

    @conference.reload

    assert_equal "1", @conference.odv_visit_id
  end
end
