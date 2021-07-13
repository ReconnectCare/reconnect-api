Rails.logger.info "NOTIFICATION SUBS\n\n"

ActiveSupport::Notifications.subscribe "request.http" do |event|
  log = RequestLog.new
  log.exception = event.payload[:exception]
  log.start = Time.at(event.time)
  log.end = Time.at(event.end)
  log.duration = event.duration

  response = event.payload[:response]
  puts response.request
  if response
    request = response.request
    if request
      body = ""
      request.body.each do |data|
        body << data
      end
      log.verb = request.verb
      log.uri = request.uri.to_s
      log.request_headers = request.headers.to_h
      log.request_body = body
    end
    log.status = response.status.code
    log.response_headers = response.headers.to_h
    log.response_body = response.body.to_s
  end

  log.save!

  Rails.logger.info "REQUEST.HTTP\n\n"
end
