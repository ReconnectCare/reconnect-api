require "test_helper"

class RequestLogsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user.reload
    @request_log = create(:request_log)
  end

  test "should get index" do
    get request_logs_url
    assert_response :success
  end

  test "should show request_log" do
    get request_log_url(@request_log)
    assert_response :success
  end
end
