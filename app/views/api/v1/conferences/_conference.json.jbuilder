json.extract! conference, :id, :sid, :start_time, :end_time
json.conference_number do
  json.partial! "api/v1/conference_numbers/conference_number", conference_number: @conference.conference_number
end
json.patient do
  json.partial! "api/v1/patients/patient", patient: @conference.patient
end
json.provider do
  if @conference.provider
    json.partial! "api/v1/providers/provider", provider: @conference.provider
  end
end
json.extract! conference, :created_at, :updated_at
json.url conference_url(conference, format: :json)
