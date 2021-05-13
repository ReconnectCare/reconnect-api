class ConferenceNumbersController < ApplicationController
  load_and_authorize_resource

  # GET /conference_numbers or /conference_numbers.json
  def index
  end

  # GET /conference_numbers/1 or /conference_numbers/1.json
  def show
  end

  # GET /conference_numbers/new
  def new
  end

  # GET /conference_numbers/1/edit
  def edit
  end

  # POST /conference_numbers or /conference_numbers.json
  def create
    @conference_number = ConferenceNumber.new(conference_number_params)

    respond_to do |format|
      if @conference_number.save
        format.html { redirect_to @conference_number, notice: "Conference number was successfully created." }
        format.json { render :show, status: :created, location: @conference_number }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @conference_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conference_numbers/1 or /conference_numbers/1.json
  def update
    respond_to do |format|
      if @conference_number.update(conference_number_params)
        format.html { redirect_to @conference_number, notice: "Conference number was successfully updated." }
        format.json { render :show, status: :ok, location: @conference_number }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @conference_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conference_numbers/1 or /conference_numbers/1.json
  def destroy
    @conference_number.destroy
    respond_to do |format|
      format.html { redirect_to conference_numbers_url, notice: "Conference number was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def conference_number_params
    params.require(:conference_number).permit(:number)
  end
end
