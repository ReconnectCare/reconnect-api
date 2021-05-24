class ContactProvidersWorker
  include Sidekiq::Worker

  def perform(conference_id, providers_json)
    # TODO Send SMS to X random available providers
    conference = Conference.find(conference_id)

    # TODO move this content to system settings object
    body = "New patient is ready for a consult. Call #{conference.conference_number.number}."

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
