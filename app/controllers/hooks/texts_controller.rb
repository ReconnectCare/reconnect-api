class Hooks::TextsController < Hooks::HooksController
  include ValidateTwilioRequests

  URL_OPTIONS = Rails.env.development? ? {host: "https://candland.ngrok.io"} : {}

  before_action :validate_twilio_request!

  # Not handling incoming texts for now
  # def create
  #   @text = TextMessage.new(
  #     number: twilio_params["From"],
  #     provider_id: twilio_params["MessageSid"],
  #     direction: TextMessage::Directions.inbound,
  #     status: twilio_params["SmsStatus"],
  #     body: twilio_params["Body"]
  #   )
  #
  #   @text.save!
  #
  #   render xml: ""
  # end

  def status
    id = params[:id]
    text = TextMessage.find(id)
    text.update(
      status: twilio_params[:MessageStatus],
      error_code: twilio_params[:ErrorCode]
    )
    render json: "", status: :no_content
  end

  private

  def twilio_params
    params.permit(
      "AccountSid",
      "ApiVersion",
      "Body",
      "From",
      "FromCity",
      "FromCountry",
      "FromState",
      "FromZip",
      "MessageSid",
      "MessageStatus",
      "ErrorCode",
      "NumMedia",
      "NumSegments",
      "SmsMessageSid",
      "SmsSid",
      "SmsStatus",
      "To",
      "ToCity",
      "ToCountry",
      "ToState",
      "ToZip"
    )
  end
end
