require "test_helper"

class CreateOnDemandAppointmentWorkerTest < ActiveSupport::TestCase
  setup do
    @conference = create(:conference, :with_provider)
  end

  test "perform" do
    mock = Minitest::Mock.new
    mock.expect :schedule_appointment, 1, [OnDemandClient::Visit]

    OnDemandClient.stub :new, mock do
      CreateOnDemandAppointmentWorker.new.perform(@conference.id)
    end

    assert_mock mock

    patient = @conference.patient
    patient.reload

    assert_equal "1", patient.odv_visit_id
  end
end
