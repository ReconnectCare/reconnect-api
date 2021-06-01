class ContactProvidersWorker
  include Sidekiq::Worker

  def perform(conference_id, providers)
    # TODO save all providers to database

    providers.each do |provider|
      SaveProvider.new(provider).call
    end

    candidates = get_candidates(providers)

    conference = Conference.find(conference_id)

    candidates.each do |candidate|
      provider_text_message = Setting.get("provider_text_message", "Please call <%= conference.number %>")
      body = Setting.render(provider_text_message, {conference: conference})

      text_message = TextMessage.new(
        conference_id: conference_id,
        status: TextMessage::Statuses.ready,
        direction: TextMessage::Directions.outbound,
        body: body,
        number: candidate.cell_phone
      )

      text_message.save!

      SendTextMessageWorker.perform_async(text_message.id)
    end
  end

  def get_candidates(providers)
    providers_to_attempt = Setting.get("providers_to_attempt", 2)

    # TODO pick X number of providers to SMS
    providers
  end
end
