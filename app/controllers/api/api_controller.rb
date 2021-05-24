class Api::ApiController < ActionController::API
  include CanCan::ControllerAdditions
  include Pagy::Backend

  before_action :prepare_exception_notifier
  before_action :set_default_format

  after_action :set_api_version_number
  after_action :count_api_request

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect} for #{current_user}"
    redirect_to root_url, alert: exception.message
  end

  rescue_from Exceptions::ApiDataError do |e|
    render status: e.status, json: {message: e.message, errors: e.errors}
  end

  # Catches everything
  # rescue_from StandardError, with: :standard_error

  check_authorization
  skip_authorization_check only: [:status]

  def status
    render json: {status: "ok", code: 200}
  end

  protected

  # Set in devise strategy
  def claims
    request.params[:claims]
  end

  def token
    request.params[:token]
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def set_default_format
    request.format = :json
  end

  def record_not_found
    render json: {}, status: :not_found
  end

  def standard_error e
    render json: {error: e.message, stack: e.backtrace}, status: 500
  end

  def set_api_version_number
    response.set_header("Accept", "application/api.rails-starter-6.com; version=1")
  end

  private

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user
    }
  end

  def count_api_request
    ApiToken.find_by(token: token).increment!(:calls) if token.present?
  end
end
