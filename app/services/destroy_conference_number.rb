class DestroyConferenceNumber
  def initialize conference_number
    @conference_number = conference_number
  end

  def call
    sid = @conference_number.sid

    twilio.incoming_phone_numbers(sid).delete

    "Destroy #{@conference_number.destroy}"
  rescue => e
    puts e
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
