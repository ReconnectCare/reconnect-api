class Hooks::VoiceController < Hooks::HooksController
  include ValidateTwilioRequests

  URL_OPTIONS = Rails.env.development? ? {protocol: "https", host: "https://candland.ngrok.io"} : {}

  before_action :validate_twilio_request!

  def create
    conference_number = twilio_params["To"]
    caller_number = twilio_params["From"]

    conference = Conference.in_progress_to(conference_number).first

    # Return handled if no conf
    if conference.nil?
      conference_over
      return render xml: builder.to_s
    end

    logger.debug "Active conference found #{conference.id}"

    # TODO: collect & update voice status
    voice_call = VoiceCall.create(
      conference: conference,
      number: caller_number,
      provider_id: twilio_params["CallSid"],
      direction: VoiceCall::Directions.inbound,
      status: VoiceCall::Statuses.in_progress
    )

    conference.voice_calls << voice_call
    conference.status = Conference::Statuses.waiting
    conference.save!

    if Provider.where(cell_phone: caller_number).exists?
      logger.debug "Found provider for #{caller_number}"

      # Provider calling, prompt them to join
      if conference.contestants.include?(caller_number)
        intro conference
      else
        logger.debug "Provider #{caller_number} not a contestant in #{conference.contestants}"
        conference_handled
      end
    else
      # Assume patient calling & start conference
      logger.debug "Assuming patient caller for #{caller_number}"

      join_conference conference
    end

    render xml: builder.to_s
  end

  def respond
    digits = twilio_params["Digits"].to_i

    # Load conf
    conference = Conference.find(params[:id])
    caller_number = twilio_params["From"]

    case digits
    when 1
      if conference.provider.nil?
        conference.update!(provider: Provider.find_by(cell_phone: caller_number))
        join_conference conference
      else
        conference_handled
      end
    else
      builder.say "Goodbye"
      builder.hangup
    end

    render xml: builder.to_s
  end

  def recorded
    conference = Conference.find(params[:id])
    if twilio_params["RecordingStatus"] == "completed"
      recording_url = twilio_params["RecordingUrl"]
      recording_sid = twilio_params["RecordingSid"]
      DownloadConferenceRecordingWorker.perform_async(conference.id, recording_url, recording_sid)
    end

    render xml: builder.to_s
  end

  def status
    conference = Conference.find(params[:id])
    status = twilio_params["StatusCallbackEvent"]

    case status
    when "conference-start"
      conference.update!(status: Conference::Statuses.in_progress)
    when "conference-end"
      conference.update!(end_time: DateTime.now, status: Conference::Statuses.completed)
    end

    render xml: builder.to_s
  end

  private

  def to_status twilio_status
    twilio_status.tr("-", "_")
  end

  def builder
    @builder ||= Twilio::TwiML::VoiceResponse.new
  end

  def intro conference
    # TODO: add system setting for message
    builder.gather(action: hooks_voice_respond_url(conference, URL_OPTIONS), input: :dtmf, numDigits: 1, actionOnEmptyResult: true) do |gather|
      gather.say(message: "Press 1 to join the conference.")
    end
  end

  def conference_over
    # TODO: add system setting for message
    builder.say(message: "The conference is over.")
    builder.hangup
  end

  def conference_handled
    # TODO: add system setting for message
    builder.say(message: "The call has been handled.")
    builder.hangup
  end

  def join_conference conference
    builder.dial do |dial|
      dial.conference(conference.id.to_s,
        max_participants: 2,
        status_callback_event: "start end join leave mute hold",
        status_callback: hooks_voice_status_url(conference, URL_OPTIONS),
        record: true,
        recording_status_callback_event: "completed",
        recording_status_callback: hooks_voice_recorded_url(conference, URL_OPTIONS))
    end
  end

  def twilio
    TwilioClient.new
  end

  def twilio_params
    params.permit(
      "AccountSid",
      "ApiVersion",
      "CallbackSource",
      "CallDuration",
      "Called",
      "CalledCity",
      "CalledCountry",
      "CalledState",
      "CalledZip",
      "Caller",
      "CallerCity",
      "CallerCountry",
      "CallerState",
      "CallerZip",
      "CallSid",
      "CallStatus",
      "Digits",
      "Direction",
      "Duration",
      "FinishedOnKey",
      "From",
      "FromCity",
      "FromCountry",
      "FromState",
      "FromZip",
      "msg",
      "To",
      "ToCity",
      "ToCountry",
      "ToState",
      "ToZip",
      "SequenceNumber",
      "SipResponseCode",
      "SpeechResult",
      "Confidence",
      "ForwardedFrom",
      "ParentCallSid",
      "ErrorCode",
      "RecordingChannels",
      "RecordingDuration",
      "RecordingSid",
      "RecordingSource",
      "RecordingStartTime",
      "RecordingStatus",
      "RecordingTrack",
      "RecordingUrl",
      "Timestamp",
      "TranscriptionSid",
      "TranscriptionStatus",
      "TranscriptionText",
      "TranscriptionType",
      "TranscriptionUrl",
      "StirVerstat",
      "StirPassportToken",
      "Coaching",
      "FriendlyName",
      "ConferenceSid",
      "EndConferenceOnExit",
      "StatusCallbackEvent",
      "StartConferenceOnEnter",
      "Hold",
      "Muted",
      "url"
    )
  end
end
