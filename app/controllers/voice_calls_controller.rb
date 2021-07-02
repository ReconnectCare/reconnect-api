class VoiceCallsController < ApplicationController
  load_and_authorize_resource

  # GET /voice_calls or /voice_calls.json
  def index
    @pagy, @voice_calls = pagy(@voice_calls.includes(:conference).order(created_at: :desc))
  end

  # GET /voice_calls/1 or /voice_calls/1.json
  def show
  end
end
