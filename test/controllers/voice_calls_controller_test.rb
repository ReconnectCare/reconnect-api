require "test_helper"

class VoiceCallsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user
    @voice_call = create(:voice_call)
  end

  test "should get index" do
    get voice_calls_url
    assert_response :success
  end

  test "should get new" do
    get new_voice_call_url
    assert_response :success
  end

  test "should create voice_call" do
    conference = create(:conference)
    assert_difference("VoiceCall.count") do
      post voice_calls_url, params: {voice_call: attributes_for(:voice_call).merge(conference_id: conference.id)}
    end

    assert_redirected_to voice_call_url(VoiceCall.order(created_at: :asc).last)
  end

  test "should show voice_call" do
    get voice_call_url(@voice_call)
    assert_response :success
  end

  test "should get edit" do
    get edit_voice_call_url(@voice_call)
    assert_response :success
  end

  test "should update voice_call" do
    patch voice_call_url(@voice_call), params: {voice_call: attributes_for(:voice_call)}
    assert_redirected_to voice_call_url(@voice_call)
  end

  test "should destroy voice_call" do
    assert_difference("VoiceCall.count", -1) do
      delete voice_call_url(@voice_call)
    end

    assert_redirected_to voice_calls_url
  end
end
