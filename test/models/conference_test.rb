require "test_helper"

class ConferenceTest < ActiveSupport::TestCase
  test "in_progress_to" do
    conference = create(:conference, end_time: nil)

    in_progress = Conference.in_progress_to(conference.conference_number.number).first

    assert_not_nil in_progress
    assert_equal in_progress.id, conference.id
  end

  test "contestants" do
    conference = create(:conference)
    assert_equal [], conference.contestants

    conference.contestants << "+13035551111"
    conference.contestants << "+13035552222"

    assert conference.save
    assert_equal ["+13035551111", "+13035552222"], conference.contestants
  end

  test "duration" do
    conference = create(:conference, start_time: DateTime.new(2021, 6, 9, 2, 30, 0), end_time: DateTime.new(2021, 6, 9, 2, 45, 30))

    assert_equal 930, conference.duration.seconds
  end
end
