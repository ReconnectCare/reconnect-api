json.extract! conference, :id, :sid, :start_time, :end_time, :conference_number_id, :provider_id, :patient_id, :created_at, :updated_at
json.url conference_url(conference, format: :json)
