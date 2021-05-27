json.extract! voice_call, :id, :provider_id, :conference_id, :direction, :status, :number, :created_at, :updated_at
json.url voice_call_url(voice_call, format: :json)
