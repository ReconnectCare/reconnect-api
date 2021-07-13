class RequestLogsController < ApplicationController
  load_and_authorize_resource

  # GET /request_logs or /request_logs.json
  def index
    @pagy, @request_logs = pagy(@request_logs)
  end

  # GET /request_logs/1 or /request_logs/1.json
  def show
  end
end
