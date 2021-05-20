module ValidateTwilioRequests
  extend ActiveSupport::Concern

  included do
    def validate_twilio_request!
      val = ::Twilio::Security::RequestValidator.new(Rails.application.credentials.twilio[:auth_token])

      url = request.url
      if request.headers["HTTP_X_ORIGINAL_HOST"].present?
        url = url.sub(request.headers["HTTP_HOST"], request.headers["HTTP_X_ORIGINAL_HOST"]).sub("http:", "https:")
      end

      is_valid = val.validate(url, twilio_params.to_h, request.headers["X-Twilio-Signature"] || "")

      unless is_valid
        Rails.logger.debug "\n\nURL: #{url}"
        Rails.logger.debug twilio_params.inspect
        twilio_params.each do |k, v|
          Rails.logger.debug "    #{k} = #{v}"
        end
      end

      return render status: :unauthorized, xml: "" unless is_valid
    end
  end
end
