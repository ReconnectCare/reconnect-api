json.extract! patient, :id, :external_id, :first_name, :middle_name, :last_name, :date_of_birth, :gender, :office_phone, :cell_phone, :email, :street, :street_2, :city, :state, :zipcode, :created_at, :updated_at
json.url patient_url(patient, format: :json)
