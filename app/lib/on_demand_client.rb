class OnDemandClient
  ROOT_URL = "https://ondemandapi.ondemandvisit.com"

  Token = Struct.new(:token, :expires_in, :created_at)

  Provider = Struct.new(:user_id, :start_time, :close_time, :provider_name, :phy_code, :cell_phone)

  Patient = Struct.new(:account_id, :first_name, :middle_name, :last_name, :dob, :gender, :office_phone, :cell_phone, :email_id, :street, :city, :state, :country, :zipcode, :is_email_verified, :reg_through) do
    def self.from_patient patient
      OnDemandClient::Patient.new(
        "ODV1058",
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

  Visit = Struct.new(:pat_id, :patient_name, :reason, :app_type, :phone_no, :phy_code, :latitude, :longitude, :current_location, :current_state, :patient_platform, :pat_platform_desc, :created_from) do
    def self.create
      OnDemandClient::Visit.new
    end
  end

  @@token = nil

  def initialize
  end

  def auth_token
    # TODO verify & test the timeout
    if @@token && Time.now.utc - @@token.created_at > 23.hours
      @@token = nil
    end
    @@token ||= refresh_token
  end

  def insert_patient od_patient
    # TODO: Get this API call working
    #
    # endpoint = "/api/Patient/"
    #
    # params = od_patient.to_h.each_with_object({}) { |(k, v), memo|
    # TODO: upcase any params ending in Id
    #   memo[k.to_s.camelcase] = v
    # }
    #
    # resp = HTTP.auth("Bearer #{auth_token.token}")
    #   .headers(accept: "application/json", 'Content-Type': "application/json")
    #   .post(full_url(endpoint), json: params)
    0
  end

  def schedule_appointment
    # TODO: Get this API call working
    #
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
      Provider.new(
        data.dig("UserID"),
        data.dig("StartTime"),
        data.dig("CloseTime"),
        data.dig("ProviderName"),
        data.dig("PhyCode"),
        data.dig("Cellphone")
      )
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
      Token.new(json.dig("access_token"), json.dig("expires_in"), DateTime.now)
    end
  end

  def full_url path
    URI.join(ROOT_URL, path)
  end
end
