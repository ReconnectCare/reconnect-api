class SendPatientToOnDemandWorker < ApplicationWorker
  def perform patient_id
    patient = Patient.find(patient_id)

    if patient.odv_id.blank?
      od_patient = OnDemandClient::Patient.from_patient(patient)

      id = OnDemandClient.new.insert_patient(od_patient)

      patient.update!(odv_id: id)
    end
  end
end
