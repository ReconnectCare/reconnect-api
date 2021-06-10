require "test_helper"

class PatientTest < ActiveSupport::TestCase
  test "save" do
    patient = create(:patient)
    assert patient.save
  end

  test "new" do
    patient = Patient.new(attributes_for(:patient, date_of_birth: "1979-03-25"))
    assert patient.save
    assert patient.reload
    assert_equal DateTime.new(1979, 3, 25), patient.date_of_birth
  end

  test "state errors" do
    patient = Patient.new(attributes_for(:patient))
    assert_raises ArgumentError do
      patient.state = "colorado"
    end
  end

  test "zipcode errors" do
    patient = Patient.new(attributes_for(:patient))
    patient.zipcode = "nop"
    refute patient.valid?

    patient.zipcode = "234"
    refute patient.valid?

    patient.zipcode = "00343"
    assert patient.valid?

    patient.zipcode = "0343-3423"
    assert patient.valid?
  end
end
