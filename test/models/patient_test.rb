require "test_helper"

class PatientTest < ActiveSupport::TestCase
  test "save" do
    patient = create(:patient)
    assert patient.save
  end
end
