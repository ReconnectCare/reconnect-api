class PatientsController < ApplicationController
  load_and_authorize_resource

  # GET /patients or /patients.json
  def index
    @pagy, @patients = pagy(@patients.order(last_name: :asc, first_name: :asc))
  end

  # GET /patients/1 or /patients/1.json
  def show
  end

  # GET /patients/new
  def new
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients or /patients.json
  def create
    @patient = Patient.new(patient_params)

    respond_to do |format|
      if @patient.save
        format.html { redirect_to @patient, notice: "Patient was successfully created." }
        format.json { render :show, status: :created, location: @patient }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patients/1 or /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to @patient, notice: "Patient was successfully updated." }
        format.json { render :show, status: :ok, location: @patient }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1 or /patients/1.json
  def destroy
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to patients_url, notice: "Patient was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def patient_params
    params.require(:patient).permit(:external_id, :first_name, :middle_name, :last_name, :date_of_birth, :gender, :office_phone, :cell_phone, :email, :street, :street_2, :city, :state, :zipcode)
  end
end
