class TwilioClient
  def self.build
    Twilio::REST::Client.new(
      Rails.application.credentials.twilio[:account_sid],
      Rails.application.credentials.twilio[:auth_token]
    )
  end

  def self.url_options
    Rails.env.development? || Rails.env.test? ? {protocol: "https", host: "https://candland.ngrok.io"} : Rails.application.config.action_mailer.default_url_options
  end
end
