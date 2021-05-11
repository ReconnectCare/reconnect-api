require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user.reload
  end

  test "index" do
    get root_url
    assert_response :success
  end
end
