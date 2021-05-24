require "test_helper"

class ContactProvidersWorkerTest < ActiveSupport::TestCase
  test "should create text messages" do
    conference = create(:conference)

    assert_difference("SendTextMessageWorker.jobs.count") do
      ContactProvidersWorker.new.perform(conference.id, {})
    end
  end
end
