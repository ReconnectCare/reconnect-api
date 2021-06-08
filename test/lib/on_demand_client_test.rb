require "test_helper"

class OnDemandClientTest < ActiveSupport::TestCase
  test "auth_token" do
  end

  test "get_available_providers" do
  end

  test "insert_patient" do
    @od_patient = OnDemandClient::Patient.new("ODV1058", "TestFirst", "M", "TestLast", "2020-11-03T14:45:42.940581+05:30", "Male", nil, "(110) 254 2546", "test@test.com", "123 main", "anytown", "CA", 239, "90121")
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
