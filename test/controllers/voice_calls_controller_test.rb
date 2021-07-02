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

  test "should show voice_call" do
    get voice_call_url(@voice_call)
    assert_response :success
  end
end
