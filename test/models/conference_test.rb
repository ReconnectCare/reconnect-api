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
end
