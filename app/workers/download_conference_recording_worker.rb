class DownloadConferenceRecordingWorker < ApplicationWorker
  def perform conference_id, recording_url, recording_sid
    conference = Conference.find(conference_id)

    recording_mp3_url = "#{recording_url}.mp3"

    resp = HTTP.get(recording_mp3_url)

    if resp.code == 200
      conference.recording.attach(io: StringIO.new(resp.to_s),
                                  filename: recording_sid + ".mp3",
                                  content_type: "audio/mpeg")
      twilio.recordings(recording_sid).delete
    end
  end

  def twilio
    @twilio ||= TwilioClient.build
  end
end
