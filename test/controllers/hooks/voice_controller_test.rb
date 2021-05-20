require "test_helper"

class Hooks::VoiceControllerTest < ActionDispatch::IntegrationTest
  # include Devise::Test::IntegrationHelpers
  # include ActiveJob::TestHelper
  #
  # setup do
  #   @user = create(:user)
  #   @patient = create(:patient, cell_phone: "+13038752721", user: @user)
  #   @voice_call = VoiceCall.create(
  #     id: "b861039f-b8bb-478f-a131-48728d4b0b27",
  #     system_number: "+17207404002",
  #     number: "+13038752721",
  #     provider_id: "CA880f7345eb289212fd6e5364ca6a615d",
  #     direction: "inbound",
  #     status: "in_progress",
  #     destination: "general"
  #   )
  # end
  #
  # def sig_header url, params
  #   val = Twilio::Security::RequestValidator.new(Rails.application.credentials.twilio[:auth_token])
  #   {"X-Twilio-Signature" => val.build_signature_for(url, params)}
  # end
  #
  # test "post create: invalid signature" do
  #   url = hooks_voice_url
  #   post url, params: {}
  #
  #   assert_response :unauthorized
  #   assert_equal "", response.body
  # end
  #
  # test "post create" do
  #   params = {
  #     "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
  #     "ApiVersion" => "2010-04-01",
  #     "Called" => "+17207404002",
  #     "CalledCity" => "no value",
  #     "CalledCountry" => "US",
  #     "CalledState" => "CO",
  #     "CalledZip" => "no value",
  #     "Caller" => "+13038752721",
  #     "CallerCity" => "DENVER",
  #     "CallerCountry" => "US",
  #     "CallerState" => "CO",
  #     "CallerZip" => "80022",
  #     "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
  #     "CallStatus" => "ringing",
  #     "Direction" => "inbound",
  #     "From" => "+13038752721",
  #     "FromCity" => "DENVER",
  #     "FromCountry" => "US",
  #     "FromState" => "CO",
  #     "FromZip" => "80022",
  #     "To" => "+17207404002",
  #     "ToCity" => "no value",
  #     "ToCountry" => "US",
  #     "ToState" => "CO",
  #     "ToZip" => "no value",
  #   }
  #   url = hooks_voice_url
  #   headers = sig_header(url, params)
  #
  #   VCR.use_cassette "hooks_voice_create_status_update" do
  #     assert_difference "VoiceCall.count" do
  #       post url, headers: headers, params: params
  #       assert_response :success
  #       assert_match "xml version", response.body
  #       assert_match "Gather", response.body
  #       assert_match "/respond", response.body
  #     end
  #   end
  #
  #   voice_call = VoiceCall.order(created_at: :asc).last
  #   assert_not_nil voice_call
  #   assert_equal "+17207404002", voice_call.system_number
  #   assert_equal "+13038752721", voice_call.number
  #   assert_equal "CA880f7345eb289212fd6e5364ca6a615d", voice_call.provider_id
  #   assert_equal "inbound", voice_call.direction
  #   assert_equal "in_progress", voice_call.status
  #   assert_equal "general", voice_call.destination
  # end
  #
  # test "respond" do
  #   params = {
  #     "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
  #     "ApiVersion" => "2010-04-01",
  #     "Called" => "+17207404002",
  #     "CalledCity" => "no value",
  #     "CalledCountry" => "US",
  #     "CalledState" => "CO",
  #     "CalledZip" => "no value",
  #     "Caller" => "+13038752721",
  #     "CallerCity" => "DENVER",
  #     "CallerCountry" => "US",
  #     "CallerState" => "CO",
  #     "CallerZip" => "80022",
  #     "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
  #     "CallStatus" => "in-progress",
  #     "Digits" => "2",
  #     "Direction" => "inbound",
  #     "FinishedOnKey" => "no value",
  #     "From" => "+13038752721",
  #     "FromCity" => "DENVER",
  #     "FromCountry" => "US",
  #     "FromState" => "CO",
  #     "FromZip" => "80022",
  #     "msg" => "Gather End",
  #     "To" => "+17207404002",
  #     "ToCity" => "no value",
  #     "ToCountry" => "US",
  #     "ToState" => "CO",
  #     "ToZip" => "no value",
  #   }
  #   url = hooks_voice_respond_url(@voice_call)
  #   headers = sig_header(url, params)
  #
  #   post url, headers: headers, params: params
  #   assert_response :success
  #   assert_match "xml version", response.body
  #   assert_match "Record", response.body
  #   assert_match "/#{@voice_call.id}/recorded", response.body
  #   assert_match "/#{@voice_call.id}/transcribed", response.body
  #
  #   @voice_call.reload
  #   assert_equal "general", @voice_call.destination
  # end
  #
  # test "recorded" do
  #   params = {
  #     "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
  #     "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
  #     "ErrorCode" => "0",
  #     "RecordingChannels" => "1",
  #     "RecordingDuration" => "2",
  #     "RecordingSid" => "REbb9313bf24cea3ecf30e647c802601c6",
  #     "RecordingSource" => "RecordVerb",
  #     "RecordingStartTime" => "Wed, 02 Dec 2020 20:42:26 +0000",
  #     "RecordingStatus" => "completed",
  #     "RecordingUrl" => "https://api.twilio.com/2010-04-01/Accounts/AC626895f618e5c09f0868ccbc91e0c93c/Recordings/REbb9313bf24cea3ecf30e647c802601c6",
  #   }
  #   url = hooks_voice_recorded_url(@voice_call)
  #   headers = sig_header(url, params)
  #
  #   assert_difference("DownloadVoiceRecordingWorker.jobs.count") do
  #     post url, headers: headers, params: params
  #   end
  #
  #   assert_response :success
  #   assert_match "xml version", response.body
  #   assert_match "Response", response.body
  #
  #   job = DownloadVoiceRecordingWorker.jobs.first
  #   args = job["args"]
  #
  #   assert_equal @voice_call.id.to_s, args[0]
  #   assert_equal "https://api.twilio.com/2010-04-01/Accounts/AC626895f618e5c09f0868ccbc91e0c93c/Recordings/REbb9313bf24cea3ecf30e647c802601c6", args[1]
  #   assert_equal "REbb9313bf24cea3ecf30e647c802601c6", args[2]
  # end
  #
  # test "transcribed" do
  #   params = {
  #     "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
  #     "ApiVersion" => "2010-04-01",
  #     "Called" => "+17207404002",
  #     "Caller" => "+13038752721",
  #     "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
  #     "CallStatus" => "completed",
  #     "Direction" => "inbound",
  #     "ForwardedFrom" => "+17207404002",
  #     "From" => "+13038752721",
  #     "RecordingSid" => "REbb9313bf24cea3ecf30e647c802601c6",
  #     "RecordingUrl" => "https://api.twilio.com/2010-04-01/Accounts/AC626895f618e5c09f0868ccbc91e0c93c/Recordings/REbb9313bf24cea3ecf30e647c802601c6",
  #     "To" => "+17207404002",
  #     "TranscriptionSid" => "TR65adebbb2780a0d954b585410204bbc3",
  #     "TranscriptionStatus" => "completed",
  #     "TranscriptionText" => "I think it's.",
  #     "TranscriptionType" => "fast",
  #     "url" => "http://candland.ngrok.io/hooks/voice/c30411aa-c83c-47eb-a35b-88bacc8f24f9/transcribed",
  #   }
  #   url = hooks_voice_transcribed_url(@voice_call)
  #   headers = sig_header(url, params)
  #
  #   post url, headers: headers, params: params
  #   assert_response :success
  #   assert_match "xml version", response.body
  #   assert_match "Response", response.body
  #
  #   @voice_call.reload
  #   assert_equal "I think it's.", @voice_call.transcription
  # end
  #
  # test "hangup" do
  #   params = {
  #     "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
  #     "ApiVersion" => "2010-04-01",
  #     "Called" => "+17207404002",
  #     "CalledCity" => "no value",
  #     "CalledCountry" => "US",
  #     "CalledState" => "CO",
  #     "CalledZip" => "no value",
  #     "Caller" => "+13038752721",
  #     "CallerCity" => "DENVER",
  #     "CallerCountry" => "US",
  #     "CallerState" => "CO",
  #     "CallerZip" => "80022",
  #     "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
  #     "CallStatus" => "in-progress",
  #     "Digits" => "2",
  #     "Direction" => "inbound",
  #     "FinishedOnKey" => "no value",
  #     "From" => "+13038752721",
  #     "FromCity" => "DENVER",
  #     "FromCountry" => "US",
  #     "FromState" => "CO",
  #     "FromZip" => "80022",
  #     "msg" => "Gather End",
  #     "To" => "+17207404002",
  #     "ToCity" => "no value",
  #     "ToCountry" => "US",
  #     "ToState" => "CO",
  #     "ToZip" => "no value",
  #   }
  #   url = hooks_voice_hangup_url(@voice_call)
  #   headers = sig_header(url, params)
  #
  #   post url, headers: headers, params: params
  #   assert_response :success
  #   assert_match "xml version", response.body
  #   assert_match "Say", response.body
  #   assert_match "Hangup", response.body
  # end
  #
  # test "status" do
  #   params = {
  #     "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
  #     "ApiVersion" => "2010-04-01",
  #     "CallbackSource" => "call-progress-events",
  #     "CallDuration" => "24",
  #     "Called" => "+13038752721",
  #     "CalledCity" => "DENVER",
  #     "CalledCountry" => "US",
  #     "CalledState" => "CO",
  #     "CalledZip" => "80022",
  #     "Caller" => "+17207404002",
  #     "CallerCity" => "no value",
  #     "CallerCountry" => "US",
  #     "CallerState" => "CO",
  #     "CallerZip" => "no value",
  #     "CallSid" => "CA880f7345eb289212fd6e5364ca6a615d",
  #     "CallStatus" => "in-progress",
  #     "Direction" => "outbound-api",
  #     "Duration" => "1",
  #     "From" => "+17207404002",
  #     "FromCity" => "no value",
  #     "FromCountry" => "US",
  #     "FromState" => "CO",
  #     "FromZip" => "no value",
  #     "RecordingDuration" => "25",
  #     "RecordingSid" => "REc3959ea5c44f1126e63da4c7a33e737e",
  #     "RecordingUrl" => "https://api.twilio.com/2010-04-01/Accounts/AC626895f618e5c09f0868ccbc91e0c93c/Recordings/REc3959ea5c44f1126e63da4c7a33e737e",
  #     "SequenceNumber" => "3",
  #     "SipResponseCode" => "200",
  #     "Timestamp" => "Thu, 14 Jan 2021 16:24:12 +0000",
  #     "To" => "+13038752721",
  #     "ToCity" => "DENVER",
  #     "ToCountry" => "US",
  #     "ToState" => "CO",
  #     "ToZip" => "80022",
  #   }
  #   url = hooks_voice_status_url
  #   headers = sig_header(url, params)
  #
  #   post url, headers: headers, params: params
  #   assert_response :success
  #
  #   @voice_call.reload
  #
  #   assert_equal "in_progress", @voice_call.status
  # end
end
