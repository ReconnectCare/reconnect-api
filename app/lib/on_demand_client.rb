class OnDemandClient
  ROOT_URL = "https://ondemandapi.ondemandvisit.com"

  Token = Struct.new(:token, :expires_in, :created_at) do
    def expired?
      Time.now.utc.to_i - created_at.to_i > expires_in
    end
  end

  Provider = Struct.new(:user_id, :start_time, :close_time, :provider_name, :phy_code, :cell_phone) do
    def self.from_json json
      Provider.new(
        json.dig("UserID"),
        json.dig("StartTime"),
        json.dig("CloseTime"),
        json.dig("ProviderName"),
        json.dig("PhyCode"),
        json.dig("Cellphone")
      )
    end

    def to_json
      {
        "UserID" => user_id,
        "StartTime" => start_time,
        "CloseTime" => close_time,
        "ProviderName" => provider_name,
        "PhyCode" => phy_code,
        "Cellphone" => cell_phone
      }
    end
  end

  Patient = Struct.new(:first_name, :middle_name, :last_name, :dob, :gender, :office_phone, :cell_phone, :email_id, :street, :city, :state, :country, :zipcode, :is_email_verified, :reg_through) do
    def self.from_patient patient
      OnDemandClient::Patient.new(
        patient.first_name,
        patient.middle_name,
        patient.last_name,
        patient.date_of_birth,
        patient.gender,
        patient.office_phone,
        patient.cell_phone,
        patient.email,
        patient.street,
        patient.city,
        patient.state,
        239,
        patient.zipcode,
        true,
        11
      )
    end
  end

  CompletedVisit = Struct.new(:pat_id, :patient_name, :reason, :app_type, :phone_no, :phy_code, :visit_start_date_time,
    :visit_join_date_time, :visit_end_date_time, :is_visit_end, :latitude, :longitude,
    :current_location, :current_state, :_patient_platform, :_pat_platform_desc, :created_from) do
    def self.create conference
      patient = conference.patient
      provider = conference.provider

      if conference.start_time.nil? || conference.end_time.nil? || conference.joined_time.nil?
        raise "Conference not completed yet."
      end

      OnDemandClient::CompletedVisit.new(
        patient.odv_id,
        "#{patient.first_name} #{patient.last_name}",
        conference.reason,
        "API",
        patient.cell_phone,
        provider&.phy_code,
        conference.start_time.iso8601,
        conference.joined_time.iso8601,
        conference.end_time.iso8601,
        true,
        "",
        "",
        patient.state,
        patient.state,
        "API",
        "API",
        3
      )
    end
  end

  Visit = Struct.new(:pat_id, :patient_name, :reason, :app_type, :phone_no, :phy_code, :latitude, :longitude, :current_location, :current_state, :_patient_platform, :_pat_platform_desc, :created_from) do
    def self.create conference
      patient = conference.patient
      provider = conference.provider

      OnDemandClient::Visit.new(
        patient.odv_id,
        "#{patient.first_name} #{patient.last_name}",
        conference.reason,
        "API",
        patient.cell_phone,
        provider.phy_code,
        "",
        "",
        patient.state,
        patient.state,
        "API",
        "API",
        3
      )
    end
  end

  VisitResponse = Struct.new(:visit_id, :token, :session_id, :patient_meeting_link) do
    def self.from_json json
      OnDemandClient::VisitResponse.new(
        json["VisitID"],
        json["Token"],
        json["SessionID"],
        json["PatientMeetingLink"]
      )
    end
  end

  @@token = nil

  def auth_token
    if @@token&.expired?
      @@token = nil
    end
    @@token ||= refresh_token
  end

  def reset_token!
    @@token = nil
  end

  def insert_patient od_patient
    endpoint = "/api/Patient/InsertPatient"

    params = camelcase_params(od_patient.to_h)

    resp = HTTP.auth("Bearer #{auth_token.token}")
      .headers(accept: "application/json", 'Content-Type': "application/json")
      .post(full_url(endpoint), json: params)

    if resp.code != 200
      ExceptionNotifier.notify_exception(
        RuntimeError.new("On Demand Insert Patient (#{resp.status})", data: {body: resp.body})
      )
      return nil
    end

    resp.parse
  end

  def schedule_appointment od_visit
    endpoint = "/api/Appointment/ScheduleVisit"

    params = {AccountId: "ODV1058"}

    json = camelcase_params(od_visit.to_h)

    resp = HTTP.auth("Bearer #{auth_token.token}")
      .headers(accept: "application/json", 'Content-Type': "application/json")
      .post(full_url(endpoint), params: params, json: json)

    if resp.code != 200
      pp resp
      return nil
    end

    OnDemandClient::VisitResponse.from_json(resp.parse)
  end

  def get_available_providers state
    endpoint = "/api/Appointment/GetOnDemandAvilableProvider"

    params = {
      AccountId: "ODV1058",
      State: state,
      VisitDateTime: DateTime.now.utc.iso8601
    }

    resp = HTTP.auth("Bearer #{auth_token.token}")
      .headers(accept: "application/json")
      .get(full_url(endpoint), params: params)

    if resp.code != 200
      ExceptionNotifier.notify_exception(
        RuntimeError.new("On Demand Available Providers (#{resp.status})", data: {body: resp.body})
      )
      return nil
    end

    json = resp.parse

    json.map { |data|
      OnDemandClient::Provider.from_json(data)
    }
  end

  private

  def refresh_token
    params = {
      grant_type: "password",
      username: Rails.application.credentials.on_demand[:username],
      password: Rails.application.credentials.on_demand[:password]
    }

    resp = HTTP.headers(accept: "application/json", 'Content-Type': "application/x-www-form-urlencoded").get(full_url("/AuthToken"), form: params)

    if resp.code != 200
      raise "On Demand Auth Error (#{resp.status}): #{resp.body}"
    else
      json = resp.parse
      Token.new(json.dig("access_token"), json.dig("expires_in"), Time.now.utc)
    end
  end

  def full_url path
    URI.join(ROOT_URL, path)
  end

  def camelcase_params hash
    hash.each_with_object({}) { |(k, v), memo|
      base_name = k.to_s
      name = base_name.camelcase
      name = name.sub(/Id\z/, "ID") if name.ends_with?("Id")
      name = lower_first_letter(name) if base_name.starts_with?("_")
      memo[name] = v
    }
  end

  def lower_first_letter str
    str[0] = str[0].downcase
    str
  end
end
