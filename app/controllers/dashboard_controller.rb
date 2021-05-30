class DashboardController < ApplicationController
  authorize_resource class: false

  def index
    @active_conferences = Conference.active_conferences.order(created_at: :desc).limit(10)

    @conferences_count = Conference.all.count
    @patients_count = Patient.all.count
    @providers_count = Provider.all.count
    @available_numbers = ConferenceNumber.available_numbers.count
    @conference_number_count = ConferenceNumber.all.count
  end
end
