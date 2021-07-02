require "test_helper"

class DestroyConferenceNumberTest < ActiveSupport::TestCase
  test "#call" do
    conference_number = ConferenceNumber.create!(
      number: "+15303850076",
      sid: "PNb96744510b9834b3fddb65cbc7196d11"
    )

    VCR.use_cassette :twilio_incoming_phone_numbers_delete do
      assert_difference "ConferenceNumber.count" => -1 do
        assert DestroyConferenceNumber.new(conference_number).call
      end
    end

    assert_equal 0, ConferenceNumber.where(sid: "PNb96744510b9834b3fddb65cbc7196d11").count
  end
end
