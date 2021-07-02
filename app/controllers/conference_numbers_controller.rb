class ConferenceNumbersController < ApplicationController
  load_and_authorize_resource

  # GET /conference_numbers or /conference_numbers.json
  def index
    @pagy, @conference_numbers = pagy(@conference_numbers.kept.order(created_at: :desc))
  end

  # GET /conference_numbers/1 or /conference_numbers/1.json
  def show
  end

  # GET /conference_numbers/new
  def new
  end

  # POST /conference_numbers or /conference_numbers.json
  def create
    @conference_number = ConferenceNumber.new

    respond_to do |format|
      if SaveConferenceNumber.new(@conference_number).call
        format.html { redirect_to @conference_number, notice: "Conference number was successfully created." }
        format.json { render :show, status: :created, location: @conference_number }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @conference_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conference_numbers/1 or /conference_numbers/1.json
  def destroy
    DestroyConferenceNumber.new(@conference_number).call
    respond_to do |format|
      format.html { redirect_to conference_numbers_url, notice: "Conference number was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def conference_number_params
  end
end
