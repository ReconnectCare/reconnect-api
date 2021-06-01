require "test_helper"

class ConferenceNumberTest < ActiveSupport::TestCase
  test "#available_numbers" do
    conference_number = create(:conference_number)

    first_available = ConferenceNumber.available_numbers.first
    assert_not_nil first_available
    assert_equal conference_number, first_available

    conference = create(:conference, conference_number: conference_number, end_time: nil)
    assert conference.ready?

    first_available = ConferenceNumber.available_numbers.first
    assert_equal 1, ConferenceNumber.count
    assert_nil first_available

    new_conference_number = create(:conference_number)
    first_available = ConferenceNumber.available_numbers.first
    assert_not_nil first_available
    assert_equal new_conference_number, first_available
  end
end
