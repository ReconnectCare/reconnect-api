class TextMessagesController < ApplicationController
  load_and_authorize_resource

  # GET /text_messages
  def index
    @pagy, @text_messages = pagy(@text_messages.includes(:conference).order(created_at: :desc))
  end

  # GET /text_messages/1
  def show
  end
end
