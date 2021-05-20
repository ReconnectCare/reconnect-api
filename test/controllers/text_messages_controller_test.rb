require "test_helper"

class TextMessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user
    @text_message = create(:text_message)
  end

  test "should get index" do
    get text_messages_url
    assert_response :success
  end

  test "should show text_message" do
    get text_message_url(@text_message)
    assert_response :success
  end
end
