class ContactProvidersWorker
  include Sidekiq::Worker

  def perform(conference_id, providers_json)
    # TODO Send SMS to X random available providers
    providers_to_attempt = Setting.get("providers_to_attempt", 2)

    conference = Conference.find(conference_id)

    provider_text_message = Setting.get("provider_text_message", "default text to providers")
    body = Setting.render(provider_text_message, {conference: conference})

    text_message = TextMessage.new(
      conference_id: conference_id,
      status: TextMessage::Statuses.ready,
      direction: TextMessage::Directions.outbound,
      body: body,
      number: "+13038752721"
    )

    text_message.save!

    SendTextMessageWorker.perform_async(text_message.id)
  end
end
