json.extract! request_log, :id, :verb, :uri, :request_headers, :request_body, :status, :response_headers, :response_body, :created_at, :updated_at
json.url request_log_url(request_log, format: :json)
