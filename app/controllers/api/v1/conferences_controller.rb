class Api::V1::ConferencesController < Api::ApiController
  authorize_resource

  def create
    @patient = Patient.find_or_initialize_by(external_id: patient_params[:external_id])
    @patient.update(patient_params)

    unless @patient.save
      raise Exceptions::ApiDataError.new("patient").set_errors(@patient.errors.messages).set_status(422)
    end

    conference_number = ConferenceNumber.first_available

    if conference_number.nil?
      raise Exceptions::ApiDataError.new("conference_number").set_errors("no available numbers").set_status(422)
    end

    @conference = Conference.new(
      start_time: DateTime.now,
      patient: @patient,
      conference_number: conference_number,
      external_id: conference_params[:external_id]
    )

    # TODO: check for available providers, error if none available (API call) -> Dump to worker
    providers = {}

    if @conference.save
      ContactProvidersWorker.perform_async(@conference.id, providers)
      render :show
    else
      raise Exceptions::ApiDataError.new("conference").set_errors(@conference.errors.messages).set_status(422)
    end
  end

  private

  def conference_params
    params.permit(:external_id)
  end

  def patient_params
    params.require(:patient).permit(:external_id, :first_name, :middle_name, :last_name, :date_of_birth, :gender, :office_phone, :cell_phone, :email, :street, :street_2, :city, :state, :zipcode)
  end
end
