class ConferencesController < ApplicationController
  load_and_authorize_resource

  # GET /conferences or /conferences.json
  def index
    @pagy, @conferences = pagy(@conferences.includes(:patient, :provider).order(start_time: :desc))
  end

  # GET /conferences/1 or /conferences/1.json
  def show
  end

  # GET /conferences/new
  def new
  end

  # GET /conferences/1/edit
  def edit
  end

  # POST /conferences or /conferences.json
  def create
    @conference = Conference.new(conference_params)

    respond_to do |format|
      if @conference.save
        format.html { redirect_to @conference, notice: "Conference was successfully created." }
        format.json { render :show, status: :created, location: @conference }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conferences/1 or /conferences/1.json
  def update
    respond_to do |format|
      if @conference.update(conference_params)
        format.html { redirect_to @conference, notice: "Conference was successfully updated." }
        format.json { render :show, status: :ok, location: @conference }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conferences/1 or /conferences/1.json
  def destroy
    @conference.destroy
    respond_to do |format|
      format.html { redirect_to conferences_url, notice: "Conference was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def conference_params
    params.require(:conference).permit(:sid, :start_time, :end_time, :conference_number_id, :provider_id, :patient_id, :status, contestants: [])
  end
end
