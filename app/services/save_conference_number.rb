class SaveConferenceNumber
  def initialize conference_number
    @conference_number = conference_number
  end

  def call
    incoming_phone_number = twilio.incoming_phone_numbers.create(
      friendly_name: "#{Rails.env.capitalize} Conf Number",
      voice_url: Rails.application.routes.url_helpers.hooks_voice_url(TwilioClient.url_options),
      status_callback: Rails.application.routes.url_helpers.hooks_call_status_url(TwilioClient.url_options),
      area_code: Setting.get("conference_number_area_code", "303")
    )

    @conference_number.number = incoming_phone_number.phone_number
    @conference_number.sid = incoming_phone_number.sid
    @conference_number.save
  rescue => e
    ExceptionNotifier.notify_exception(
      e,
      data: {call: "Failed to provision phone number", conference_number: @conference_number.inspect}
    )
    false
  end

  private

  def twilio
    @twilio ||= TwilioClient.build
  end
end
