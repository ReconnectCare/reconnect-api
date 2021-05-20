require "test_helper"

class Hooks::TextsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  setup do
    @user = create(:user)
    # @patient = create(:patient, cell_phone: "+13038752721", user: @user)
    @conference = create(:conference)
  end

  def sig_header url, params
    val = Twilio::Security::RequestValidator.new(Rails.application.credentials.twilio[:auth_token])
    {"X-Twilio-Signature" => val.build_signature_for(url, params)}
  end

  test "status" do
    text = create(:text_message)

    params = {"SmsSid" => "SM625442a57da44b1880fd7521d452eee1", "SmsStatus" => "sent", "MessageStatus" => "sent", "To" => "+13038752721", "MessageSid" => "SM625442a57da44b1880fd7521d452eee1", "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c", "From" => "+17207404002", "ApiVersion" => "2010-04-01"}

    url = hooks_text_status_url(text)
    headers = sig_header(url, params)
    post url, headers: headers, params: params
    assert_response :no_content

    assert text.reload
    assert_equal "sent", text.status
  end

  test "status: error" do
    text = create(:text_message)

    params = {"ErrorCode" => "30006", "SmsSid" => "SM625442a57da44b1880fd7521d452eee1", "SmsStatus" => "undelivered", "MessageStatus" => "undelivered", "To" => "+13038752721", "MessageSid" => "SM625442a57da44b1880fd7521d452eee1", "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c", "From" => "+17207404002", "ApiVersion" => "2010-04-01"}

    url = hooks_text_status_url(text)
    headers = sig_header(url, params)
    post url, headers: headers, params: params
    assert_response :no_content

    assert text.reload
    assert_equal "undelivered", text.status
    assert_equal "30006", text.error_code
  end

  test "post create: invalid signature" do
    skip "not supported right now"
    # url = hooks_texts_url
    # post url, params: {}
    #
    # assert_response :unauthorized
    # assert_equal "", response.body
  end

  test "post create" do
    skip "not supported right now"
    # params = {
    #   "AccountSid" => "AC626895f618e5c09f0868ccbc91e0c93c",
    #   "ApiVersion" => "2010-04-01",
    #   "Body" => "Test",
    #   "From" => "+13038752721",
    #   "FromCity" => "DENVER",
    #   "FromCountry" => "US",
    #   "FromState" => "CO",
    #   "FromZip" => "80022",
    #   "MessageSid" => "SM1edb7badc4be9509289b95142453f9bb",
    #   "NumMedia" => "0",
    #   "NumSegments" => "1",
    #   "SmsMessageSid" => "SM1edb7badc4be9509289b95142453f9bb",
    #   "SmsSid" => "SM1edb7badc4be9509289b95142453f9bb",
    #   "SmsStatus" => "received",
    #   "To" => "+17207404002",
    #   "ToCity" => "no value",
    #   "ToCountry" => "US",
    #   "ToState" => "CO",
    #   "ToZip" => "no value"
    # }
    # url = hooks_texts_url
    # headers = sig_header(url, params)
    #
    # assert_difference "TextMessage.count" do
    #   post url, headers: headers, params: params
    #   assert_response :success
    #   assert_equal "", response.body
    # end
    #
    # text = TextMessage.order(created_at: :asc).last
    # assert_not_nil text
    # assert_equal "+13038752721", text.number
    # assert_equal "SM1edb7badc4be9509289b95142453f9bb", text.provider_id
    # assert_equal "Test", text.body
    # assert_equal TextMessage::Statuses.received, text.status
    # assert_equal TextMessage::Directions.inbound, text.direction
  end
end
