require "test_helper"

class OnDemandClientTest < ActiveSupport::TestCase
  test "auth_token" do
  end

  test "Token" do
    token = OnDemandClient::Token.new("XSP_yCkMExL9eqVt", 1799, Time.now.utc)
    refute token.expired?

    token = OnDemandClient::Token.new("XSP_yCkMExL9eqVt", 1799, Time.at(Time.now.utc.to_i - 1800))
    assert token.expired?
  end

  test "get_available_providers" do
  end

  test "schedule_appointment" do
    conference = create(:conference, :with_provider)
    visit = OnDemandClient::Visit.create(conference)
    visit.phy_code = "DC6429"
    visit.pat_id = 27769
    visit.patient_name = "DEMOAPI TEST"
    visit.reason = "Covid Symptoms"
    visit.app_type = "Video"
    visit.phone_no = "(100) 000-0000"
    visit.current_location = "CA"
    visit.current_state = "CA"

    OnDemandClient.new.reset_token!
    VCR.use_cassette :ondemand_schedule_appointment do
      resp = OnDemandClient.new.schedule_appointment visit
      assert_equal 23632.0, resp.visit_id
    end
  end

  test "completed_appointment" do
    conference = create(:conference, :with_provider,
      start_time: DateTime.now.utc.iso8601,
      joined_time: DateTime.now.utc.iso8601,
      end_time: DateTime.now.utc.iso8601)

    visit = OnDemandClient::CompletedVisit.create(conference)
    visit.phy_code = "DC6429"
    visit.pat_id = 27769
    visit.patient_name = "DEMOAPI TEST"
    visit.reason = "Covid Symptoms"
    visit.app_type = "Video"
    visit.phone_no = "(100) 000-0000"
    visit.current_location = "CA"
    visit.current_state = "CA"

    OnDemandClient.new.reset_token!
    VCR.use_cassette :ondemand_completed_appointment do
      resp = OnDemandClient.new.schedule_appointment visit
      assert_equal 23406.0, resp.visit_id
    end
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
    assert_equal "", visit.latitude
    assert_equal "", visit.longitude
    assert_equal conference.patient.state, visit.current_location
    assert_equal conference.patient.state, visit.current_state
    assert_equal "API", visit._patient_platform
    assert_equal "API", visit._pat_platform_desc
    assert_equal 3, visit.created_from
  end

  test "CompletedVisit#create" do
    conference = create(:conference, :with_provider)

    assert_raise "Conference not completed yet." do
      OnDemandClient::CompletedVisit.create(conference)
    end

    conference.start_time = DateTime.new.utc
    conference.joined_time = DateTime.new.utc
    conference.end_time = DateTime.new.utc

    visit = OnDemandClient::CompletedVisit.create(conference)

    assert_equal conference.patient.odv_id, visit.pat_id
    assert_equal conference.patient.first_name + " " + conference.patient.last_name, visit.patient_name
    assert_equal conference.reason, visit.reason
    assert_equal "API", visit.app_type
    assert_equal conference.patient.cell_phone, visit.phone_no
    assert_equal conference.provider.phy_code, visit.phy_code
    assert_equal "", visit.latitude
    assert_equal "", visit.longitude
    assert_equal conference.patient.state, visit.current_location
    assert_equal conference.patient.state, visit.current_state
    assert_equal conference.start_time.iso8601, visit.visit_start_date_time
    assert_equal conference.joined_time.iso8601, visit.visit_join_date_time
    assert_equal conference.end_time.iso8601, visit.visit_end_date_time
    assert visit.is_visit_end
    assert_equal "API", visit._patient_platform
    assert_equal "API", visit._pat_platform_desc
    assert_equal 3, visit.created_from
  end

  test "Patient#from_patient" do
    patient = create(:patient)

    od_patient = OnDemandClient::Patient.from_patient(patient)

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

  test "VisitResponse#from_json" do
    json_str = '{"VisitID":23405.0,"Token":"T1==cGFydG5lcl9pZD00NTgzMTkxMiZzaWc9MDRjMmU2NzA1YWI2OGY2YzRlMzA4ZTkzMzYyZjNlZjk3MWM4OWQ1NzpzZXNzaW9uX2lkPTFfTVg0ME5UZ3pNVGt4TW41LU1UWXlOVEE0TVRreE5qTTNNbjQzVG05TldqbExTbTVTT0U4MmNYQk9iMVJUVkU1WlFtcC1VSDQmY3JlYXRlX3RpbWU9MTYyNTA4MTcyOSZub25jZT04NTU0OTYmcm9sZT1QVUJMSVNIRVImZXhwaXJlX3RpbWU9MTYyNTY4NjUyOSZjb25uZWN0aW9uX2RhdGE9bmFtZSUzZERFTU9BUEkrVEVTVA==","SessionID":"1_MX40NTgzMTkxMn5-MTYyNTA4MTkxNjM3Mn43Tm9NWjlLSm5SOE82cXBOb1RTVE5ZQmp-UH4","PatientMeetingLink":"https://app.reconnectcare.com/VisitSessionRoom.aspx?room=50682377&PID=Mjc3Njk="}'

    json = JSON.parse(json_str)

    visit_response = OnDemandClient::VisitResponse.from_json(json)

    assert_equal 23405.0, visit_response.visit_id
    assert_equal "T1==cGFydG5lcl9pZD00NTgzMTkxMiZzaWc9MDRjMmU2NzA1YWI2OGY2YzRlMzA4ZTkzMzYyZjNlZjk3MWM4OWQ1NzpzZXNzaW9uX2lkPTFfTVg0ME5UZ3pNVGt4TW41LU1UWXlOVEE0TVRreE5qTTNNbjQzVG05TldqbExTbTVTT0U4MmNYQk9iMVJUVkU1WlFtcC1VSDQmY3JlYXRlX3RpbWU9MTYyNTA4MTcyOSZub25jZT04NTU0OTYmcm9sZT1QVUJMSVNIRVImZXhwaXJlX3RpbWU9MTYyNTY4NjUyOSZjb25uZWN0aW9uX2RhdGE9bmFtZSUzZERFTU9BUEkrVEVTVA==", visit_response.token
    assert_equal "1_MX40NTgzMTkxMn5-MTYyNTA4MTkxNjM3Mn43Tm9NWjlLSm5SOE82cXBOb1RTVE5ZQmp-UH4", visit_response.session_id
    assert_equal "https://app.reconnectcare.com/VisitSessionRoom.aspx?room=50682377&PID=Mjc3Njk=", visit_response.patient_meeting_link
  end
end
