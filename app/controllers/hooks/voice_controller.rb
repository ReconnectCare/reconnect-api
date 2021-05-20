class Hooks::VoiceController < Hooks::HooksController
  include ValidateTwilioRequests

  URL_OPTIONS = Rails.env.development? ? {protocol: "https", host: "https://candland.ngrok.io"} : {}

  before_action :validate_twilio_request!
  before_action :load_voice_call, except: [:create, :status]

  def create
    @voice_call = VoiceCall.create(
      system_number: twilio_params["To"],
      number: twilio_params["From"],
      provider_id: twilio_params["CallSid"],
      direction: VoiceCall::Directions.inbound,
      status: VoiceCall::Statuses.in_progress,
      destination: VoiceCall::Destinations.general
    )

    intro
    render xml: builder.to_s
  end

  def respond
    digits = twilio_params["Digits"].to_i

    render xml: builder.to_s
  end

  def recorded
    # if twilio_params["RecordingStatus"] == "completed"
    #   recording_url = twilio_params["RecordingUrl"]
    #   recording_sid = twilio_params["RecordingSid"]
    #   DownloadVoiceRecordingWorker.perform_async(@voice_call.id, recording_url, recording_sid)
    # end

    render xml: builder.to_s
  end

  def status
    call_sid = twilio_params["CallSid"]
    @voice_call = VoiceCall.find_by(provider_id: call_sid)
    @voice_call.update(status: to_status(twilio_params["CallStatus"]))
    render xml: builder.to_s
  end

  def transcribed
    @voice_call.update(transcription: twilio_params["TranscriptionText"])
    render xml: builder.to_s
  end

  def hangup
    builder.say(message: "Thank you")
    builder.hangup
    render xml: builder.to_s
  end

  private

  def to_status twilio_status
    twilio_status.tr("-", "_")
  end

  def builder
    @builder ||= Twilio::TwiML::VoiceResponse.new
  end

  def intro
    builder.gather(action: hooks_voice_respond_url(@voice_call, URL_OPTIONS), input: :dtmf, numDigits: 1, actionOnEmptyResult: true) do |gather|
      gather.say(message: "Press 1 to join the conference.")
    end
  end

  def load_voice_call
    @voice_call = VoiceCall.find(params[:id])
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
      "url"
    )
  end
end
