require "test_helper"

class DestroyConferenceNumberTest < ActiveSupport::TestCase
  test "#call" do
    conference_number = ConferenceNumber.create!(
      number: "+15303850076",
      sid: "PNb96744510b9834b3fddb65cbc7196d11"
    )

    VCR.use_cassette :twilio_incoming_phone_numbers_delete do
      assert_difference "ConferenceNumber.count" => 0 do
        assert DestroyConferenceNumber.new(conference_number).call
      end
    end

    conference_number.reload
    assert conference_number.discarded?
  end
end
