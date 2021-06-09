class CreateOnDemandAppointmentWorker < ApplicationWorker
  def perform conference_id
    conference = Conference.find(conference_id)

    od_visit = OnDemandClient::Visit.create(conference)

    visit_id = OnDemandClient.new.schedule_appointment od_visit

    conference.update!(odv_visit_id: visit_id)
  end
end
