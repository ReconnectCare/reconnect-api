class Hooks::HooksController < ActionController::API
  include CanCan::ControllerAdditions
  include Pagy::Backend

  skip_authorization_check

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect} for #{current_user}"
    render status: :unauthorized, json: {message: "Unauthorized", errors: nil}
  end

  rescue_from Exceptions::ApiDataError do |e|
    render status: e.status, json: {message: e.message, errors: e.errors}
  end
end
