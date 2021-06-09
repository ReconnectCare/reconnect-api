require "test_helper"

class OnDemandClientTest < ActiveSupport::TestCase
  test "auth_token" do
  end

  test "get_available_providers" do
  end

  test "schedule_appointment" do
    conference = create(:conference, :with_provider)
    visit = OnDemandClient::Visit.create(conference)

    # OnDemandClient.new.schedule_appointment visit
  end

  test "insert_patient" do
    od_patient = OnDemandClient::Patient.new("ODV1058", "TestFirst", "M", "TestLast", "2020-11-03T14:45:42.940581+05:30", "Male", nil, "(110) 254 2546", "test@test.com", "123 main", "anytown", "CA", 239, "90121")

    VCR.use_cassette :odv_insert_patient do
      id = OnDemandClient.new.insert_patient(od_patient)
      assert_not_nil id
    end
  end

  test "Visit#create" do
    conference = create(:conference, :with_provider)

    visit = OnDemandClient::Visit.create(conference)

    assert_equal conference.patient.odv_id, visit.pat_id
    assert_equal conference.patient.first_name + " " + conference.patient.last_name, visit.patient_name
    assert_equal conference.reason, visit.reason
    assert_equal "API", visit.app_type
    assert_equal conference.patient.cell_phone, visit.phone_no
    assert_equal conference.provider.phy_code, visit.phy_code
    assert_equal 0, visit.latitude
    assert_equal 0, visit.longitude
    assert_equal conference.patient.state, visit.current_location
    assert_equal conference.patient.state, visit.current_state
    assert_equal "API", visit.patient_platform
    assert_equal "API", visit.pat_platform_desc
    assert_equal 3, visit.created_from
  end

  test "Patient#from_patient" do
    patient = create(:patient)

    od_patient = OnDemandClient::Patient.from_patient(patient)

    assert_equal "ODV1058", od_patient.account_id
    assert_equal patient.first_name, od_patient.first_name
    assert_equal patient.middle_name, od_patient.middle_name
    assert_equal patient.last_name, od_patient.last_name
    assert_equal patient.date_of_birth, od_patient.dob
    assert_equal patient.gender, od_patient.gender
    assert_nil od_patient.office_phone
    assert_equal patient.cell_phone, od_patient.cell_phone
    assert_equal patient.email, od_patient.email_id
    assert_equal patient.street, od_patient.street
    assert_equal patient.city, od_patient.city
    assert_equal patient.state, od_patient.state
    assert_equal 239, od_patient.country
    assert_equal patient.zipcode, od_patient.zipcode
    assert_equal true, od_patient.is_email_verified
    assert_equal 11, od_patient.reg_through
  end
end
