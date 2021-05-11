class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  include Pagy::Backend

  before_action :prepare_exception_notifier

  check_authorization unless: :devise_controller?

  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  protected

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect} for #{current_user}"
    redirect_to root_url, alert: exception.message
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  private

  def after_sign_in_path_for(resource)
    request.env["omniauth.origin"] || stored_location_for(resource) || dashboard_url
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user,
    }
  end
end
