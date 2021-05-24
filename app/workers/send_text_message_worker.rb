class SendTextMessageWorker < ApplicationWorker
  def perform text_message_id
    text_message = TextMessage.find(text_message_id)

    return unless text_message.ready?
    return unless text_message.outbound?

    send_text_message(text_message)
  end

  private

  def send_text_message text_message
    # url_options = Rails.env.development? ? {protocol: "https", host: "https://candland.ngrok.io"} : Rails.application.config.action_mailer.default_url_options

    routes = Rails.application.routes.url_helpers

    message = twilio.messages.create(
      to: text_message.number,
      from: TextMessage.site_number,
      status_callback: routes.hooks_text_status_url(text_message.id, TwilioClient.url_options),
      body: text_message.body
    )

    text_message.provider_id = message.sid
    text_message.status = message.status
    text_message.save!
  end

  def twilio
    @twilio ||= TwilioClient.build
  end
end
