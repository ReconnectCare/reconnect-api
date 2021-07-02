require "test_helper"

class SaveConferenceNumberTest < ActiveSupport::TestCase
  test "#call" do
    VCR.use_cassette :twilio_incoming_phone_numbers do
      assert_difference "ConferenceNumber.count" => 1 do
        assert SaveConferenceNumber.new(ConferenceNumber.new).call
      end
    end

    conference_number = ConferenceNumber.order(created_at: :asc).first

    assert_not_nil conference_number

    assert_equal "+15303850076", conference_number.number
    assert_equal "PNb96744510b9834b3fddb65cbc7196d11", conference_number.sid
  end
end
