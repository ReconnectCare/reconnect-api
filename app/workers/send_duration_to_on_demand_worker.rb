class SendDurationToOnDemandWorker < ApplicationWorker
  def perform conference_id
    conference = Conference.find(conference_id)

    return unless conference.completed?

    od_duration = OnDemandClient::Duration.create(conference)

    OnDemandClient.new.send_duration od_duration
  end
end
