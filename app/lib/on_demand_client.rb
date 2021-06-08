class OnDemandClient
  ROOT_URL = "https://ondemandapi.ondemandvisit.com"

  Token = Struct.new(:token, :expires_in, :created_at)
  Provider = Struct.new(:user_id, :start_time, :close_time, :provider_name, :phy_code, :cell_phone)

  @@token = nil

  def initialize
  end

  def auth_token
    if @@token && Time.now.utc - @@token.created_at > 23.hours
      @@token = nil
    end
    @@token ||= refresh_token
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
