require "test_helper"

class DownloadConferenceRecordingWorkerTest < ActiveJob::TestCase
  test "perform" do
    conference = create(:conference)

    recording_sid = "REaca5087b05379c9d2308281a94ad4876"
    recording_url = "https://api.twilio.com/2010-04-01/Accounts/AC13816613a08b39cfa7b42ee9505fa77d/Recordings/REaca5087b05379c9d2308281a94ad4876"

    VCR.use_cassette :twilio_download_recording do
      DownloadConferenceRecordingWorker.new.perform(conference.id, recording_url, recording_sid)
    end

    conference.reload
    assert_equal "REaca5087b05379c9d2308281a94ad4876.mp3", conference.recording.blob.filename.to_s
    assert_equal "audio/mpeg", conference.recording.blob.content_type
    assert conference.recording.attached?
  end
end
