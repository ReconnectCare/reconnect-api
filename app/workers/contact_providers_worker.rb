class ContactProvidersWorker
  include Sidekiq::Worker

  def perform(conference_id, providers_json)
    providers = providers_json.map { |json| OnDemandClient::Provider.from_json(json) }
    providers.each do |provider|
      SaveProvider.new(provider).call
    end

    contestants = get_contestants(providers)

    conference = Conference.find(conference_id)
    contestant_numbers = contestants.map { |c| PhonyRails.normalize_number(c.cell_phone, country_code: "US") }
    conference.update(contestants: contestant_numbers)

    contestants.each do |contestant|
      provider_text_message = Setting.get("provider_text_message", "Please call <%= conference.number_link %>")
      body = Setting.render(provider_text_message, {conference: conference})

      text_message = TextMessage.new(
        conference_id: conference_id,
        status: TextMessage::Statuses.ready,
        direction: TextMessage::Directions.outbound,
        body: body,
        number: contestant.cell_phone
      )

      text_message.save!

      SendTextMessageWorker.perform_async(text_message.id)
    end
  end

  def get_contestants(providers)
    providers_to_attempt = Setting.get("providers_to_attempt", 2)

    from = providers.dup
    contestants = []

    while from.count > 0 && contestants.count < providers_to_attempt
      idx = SecureRandom.rand(from.count - 1)
      contestants << from.delete_at(idx)
    end

    contestants
  end
end
