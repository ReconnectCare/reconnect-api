class SendPatientToOnDemandWorker < ApplicationWorker
  def perform conference_id
    conference = Conference.find(conference_id)

    od_patient = OnDemandClient::Patient.from_patient(conference.patient)

    id = OnDemandClient.new.insert_patient(od_patient)

    conference.patient.update!(odv_id: id)
  end
end
