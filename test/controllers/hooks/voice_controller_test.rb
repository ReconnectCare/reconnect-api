require "test_helper"

class Hooks::VoiceControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  setup do
    @conference = create(:conference,
      end_time: nil,
      conference_number: create(:conference_number, number: "+17207041440"),
      contestants: ["+13038752721"])

    @provider = create(:provider, cell_phone: "+13038752721")
    @provider_second = create(:provider, cell_phone: "+13038750000")

    # @voice_call = VoiceCall.create(
    #   id: "b861039f-b8bb-478f-a131-48728d4b0b27",
    #   number: "+13038752721",
    #   conference_id: conference.id,
    #   direction: "inbound",
    #   status: "in_progress"
    # )

    assert_equal Conference::Statuses.ready, @conference.status
  end

  def sig_header url, params
    val = Twilio::Security::RequestValidator.new(Rails.application.credentials.twilio[:auth_token])
    {"X-Twilio-Signature" => val.build_signature_for(url, params)}
  end

  test "post create: invalid signature" do
    url = hooks_voice_url
    post url, params: {}

    assert_response :unauthorized
    assert_equal "", response.body
  end

  test "post create - provider - conference not in progress" do
    assert @conference.update(end_time: DateTime.now, status: :completed)

    params = {
      "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
      "ApiVersion" => "2010-04-01",
      "Called" => "+17207404002",
      "CalledCity" => "no value",
      "CalledCountry" => "US",
      "CalledState" => "CO",
      "CalledZip" => "no value",
      "Caller" => "+13038752721",
      "CallerCity" => "DENVER",
      "CallerCountry" => "US",
      "CallerState" => "CO",
      "CallerZip" => "80022",
      "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
      "CallStatus" => "ringing",
      "Direction" => "inbound",
      "From" => "+13035550000",
      "FromCity" => "DENVER",
      "FromCountry" => "US",
      "FromState" => "CO",
      "FromZip" => "80022",
      "To" => "+17207041440",
      "ToCity" => "no value",
      "ToCountry" => "US",
      "ToState" => "CO",
      "ToZip" => "no value"
    }
    url = hooks_voice_url
    headers = sig_header(url, params)

    assert_no_difference "VoiceCall.count" do
      post url, headers: headers, params: params
      assert_response :success
      assert_match "xml version", response.body
      assert_match "Say", response.body
      assert_match "Hangup", response.body
    end
  end

  test "post create - patient - join conference" do
    params = {
      "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
      "ApiVersion" => "2010-04-01",
      "Called" => "+17207404002",
      "CalledCity" => "no value",
      "CalledCountry" => "US",
      "CalledState" => "CO",
      "CalledZip" => "no value",
      "Caller" => "+13038752721",
      "CallerCity" => "DENVER",
      "CallerCountry" => "US",
      "CallerState" => "CO",
      "CallerZip" => "80022",
      "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
      "CallStatus" => "ringing",
      "Direction" => "inbound",
      "From" => "+13035550000",
      "FromCity" => "DENVER",
      "FromCountry" => "US",
      "FromState" => "CO",
      "FromZip" => "80022",
      "To" => "+17207041440",
      "ToCity" => "no value",
      "ToCountry" => "US",
      "ToState" => "CO",
      "ToZip" => "no value"
    }
    url = hooks_voice_url
    headers = sig_header(url, params)

    assert_difference "VoiceCall.count" do
      post url, headers: headers, params: params
      assert_response :success
      assert_match "xml version", response.body
      assert_match "Dial", response.body
      assert_match "Conference", response.body
      assert_match @conference.id.to_s, response.body
    end

    @conference.reload

    assert_equal 1, @conference.voice_calls.count
    assert_equal Conference::Statuses.waiting, @conference.status
  end

  test "post create - provider - gather input" do
    params = {
      "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
      "ApiVersion" => "2010-04-01",
      "Called" => "+17207404002",
      "CalledCity" => "no value",
      "CalledCountry" => "US",
      "CalledState" => "CO",
      "CalledZip" => "no value",
      "Caller" => "+13038752721",
      "CallerCity" => "DENVER",
      "CallerCountry" => "US",
      "CallerState" => "CO",
      "CallerZip" => "80022",
      "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
      "CallStatus" => "ringing",
      "Direction" => "inbound",
      "From" => "+13038752721",
      "FromCity" => "DENVER",
      "FromCountry" => "US",
      "FromState" => "CO",
      "FromZip" => "80022",
      "To" => "+17207041440",
      "ToCity" => "no value",
      "ToCountry" => "US",
      "ToState" => "CO",
      "ToZip" => "no value"
    }
    url = hooks_voice_url
    headers = sig_header(url, params)

    assert_difference "VoiceCall.count" do
      post url, headers: headers, params: params
      assert_response :success
      assert_match "xml version", response.body
      assert_match "Gather", response.body
      assert_match "/#{@conference.id}/respond", response.body
    end

    voice_call = VoiceCall.order(created_at: :asc).last
    assert_not_nil voice_call
    assert_equal "+13038752721", voice_call.number
    assert_equal "CA880f7345eb289212fd6e5364ca6a615d", voice_call.provider_id
    assert_equal "inbound", voice_call.direction
    assert_equal "in_progress", voice_call.status
    assert_equal @conference, voice_call.conference

    @conference.reload

    assert_equal 1, @conference.voice_calls.count
    assert_equal Conference::Statuses.waiting, @conference.status
  end

  test "respond - 1 to join - provider already joined" do
    @conference.provider = @provider
    assert @conference.save

    params = {
      "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
      "ApiVersion" => "2010-04-01",
      "Called" => "+17207404002",
      "CalledCity" => "no value",
      "CalledCountry" => "US",
      "CalledState" => "CO",
      "CalledZip" => "no value",
      "Caller" => "+13038752721",
      "CallerCity" => "DENVER",
      "CallerCountry" => "US",
      "CallerState" => "CO",
      "CallerZip" => "80022",
      "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
      "CallStatus" => "in-progress",
      "Digits" => "1",
      "Direction" => "inbound",
      "FinishedOnKey" => "no value",
      "From" => "+13038750000",
      "FromCity" => "DENVER",
      "FromCountry" => "US",
      "FromState" => "CO",
      "FromZip" => "80022",
      "msg" => "Gather End",
      "To" => "+17207404002",
      "ToCity" => "no value",
      "ToCountry" => "US",
      "ToState" => "CO",
      "ToZip" => "no value"
    }
    url = hooks_voice_respond_url(@conference.id)
    headers = sig_header(url, params)

    post url, headers: headers, params: params
    assert_response :success
    assert_match "xml version", response.body
    assert_match "Say", response.body
    assert_match "Hangup", response.body
  end

  test "respond - 1 to join - no provider yet" do
    params = {
      "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
      "ApiVersion" => "2010-04-01",
      "Called" => "+17207404002",
      "CalledCity" => "no value",
      "CalledCountry" => "US",
      "CalledState" => "CO",
      "CalledZip" => "no value",
      "Caller" => "+13038752721",
      "CallerCity" => "DENVER",
      "CallerCountry" => "US",
      "CallerState" => "CO",
      "CallerZip" => "80022",
      "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
      "CallStatus" => "in-progress",
      "Digits" => "1",
      "Direction" => "inbound",
      "FinishedOnKey" => "no value",
      "From" => "+13038752721",
      "FromCity" => "DENVER",
      "FromCountry" => "US",
      "FromState" => "CO",
      "FromZip" => "80022",
      "msg" => "Gather End",
      "To" => "+17207404002",
      "ToCity" => "no value",
      "ToCountry" => "US",
      "ToState" => "CO",
      "ToZip" => "no value"
    }
    url = hooks_voice_respond_url(@conference.id)
    headers = sig_header(url, params)

    post url, headers: headers, params: params
    assert_response :success
    assert_match "xml version", response.body
    assert_match "Dial", response.body
    assert_match "Conference", response.body
    assert_match @conference.id, response.body
    assert_match "record", response.body
    assert_match "/#{@conference.id}/recorded", response.body
    assert_match "/#{@conference.id}/status", response.body

    @conference.reload

    assert_not_nil @conference.provider
  end

  test "status should be in_progress after second participant joins" do
    send_status @conference, "conference-start"

    @conference.reload

    assert_equal Conference::Statuses.in_progress, @conference.status
    assert_nil @conference.end_time
  end

  test "status should be completed on conference-end" do
    send_status @conference, "conference-end"

    @conference.reload

    assert_equal Conference::Statuses.completed, @conference.status
    assert_not_nil @conference.end_time
  end

  test "recorded" do
    params = {
      "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
      "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
      "ErrorCode" => "0",
      "RecordingChannels" => "1",
      "RecordingDuration" => "2",
      "RecordingSid" => "REbb9313bf24cea3ecf30e647c802601c6",
      "RecordingSource" => "RecordVerb",
      "RecordingStartTime" => "Wed, 02 Dec 2020 20:42:26 +0000",
      "RecordingStatus" => "completed",
      "RecordingUrl" => "https://api.twilio.com/2010-04-01/Accounts/AC626895f618e5c09f0868ccbc91e0c93c/Recordings/REbb9313bf24cea3ecf30e647c802601c6"
    }
    url = hooks_voice_recorded_url(@conference)
    headers = sig_header(url, params)

    assert_difference("DownloadConferenceRecordingWorker.jobs.count") do
      post url, headers: headers, params: params
    end

    assert_response :success
    assert_match "xml version", response.body
    assert_match "Response", response.body

    job = DownloadConferenceRecordingWorker.jobs.first
    args = job["args"]

    assert_equal @conference.id.to_s, args[0]
    assert_equal "https://api.twilio.com/2010-04-01/Accounts/AC626895f618e5c09f0868ccbc91e0c93c/Recordings/REbb9313bf24cea3ecf30e647c802601c6", args[1]
    assert_equal "REbb9313bf24cea3ecf30e647c802601c6", args[2]
  end

  def send_status conference, status
    params = {
      "AccountSid" => "AC13816613a08b39cfa7b42ee9505fa77d",
      "CallSid" => "CAe3a028d450e01ff2489bc8625bf756bb",
      "Coaching" => "false",
      "ConferenceSid" => "CF3930fd282149bfb30540168946cb0577",
      "EndConferenceOnExit" => "false",
      "FriendlyName" => "b91ed172-ec99-4861-a3c9-8f7298353427",
      "Hold" => "false",
      "Muted" => "false",
      "SequenceNumber" => "10",
      "StartConferenceOnEnter" => "true",
      "StatusCallbackEvent" => status,
      "Timestamp" => "Thu, 27 May 2021 21:39:55 +0000"
    }
    url = hooks_voice_status_url(conference)
    headers = sig_header(url, params)

    post url, headers: headers, params: params
    assert_response :success
  end
end
