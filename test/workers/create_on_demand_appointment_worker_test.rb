require "test_helper"

class CreateOnDemandAppointmentWorkerTest < ActiveSupport::TestCase
  setup do
    @od_patient = OnDemandClient::Patient.new("ODV1058", "TestFirst", "M", "TestLast", "2020-11-03T14:45:42.940581+05:30", "Male", nil, "(110) 254 2546", "test@test.com", "123 main", "anytown", "CA", 239, "90121")

    @patient = create(:patient)

    @conference = create(:conference, patient: @patient)
  end

  test "perform" do
    fail IMPL
    # mock = Minitest::Mock.new
    # mock.expect :insert_patient, 1, [OnDemandClient::Patient]
    #
    # OnDemandClient.stub :new, mock do
    #   SendPatientToOnDemandWorker.new.perform(@conference.id)
    # end
    #
    # assert_mock mock
    #
    # patient = @conference.patient
    # patient.reload
    #
    # assert_equal "1", patient.odv_id
  end
end
