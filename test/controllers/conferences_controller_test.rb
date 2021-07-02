require "test_helper"

class ConferencesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user.reload
    @conference = create(:conference)
  end

  test "should get index" do
    get conferences_url
    assert_response :success
  end

  test "should get new" do
    get new_conference_url
    assert_response :success
  end

  test "should create conference" do
    assert_difference("Conference.count") do
      post conferences_url, params: {conference: attributes_for(:conference).merge(patient_id: create(:patient).id, conference_number_id: create(:conference_number).id)}
    end

    assert_redirected_to conference_url(Conference.order(created_at: :asc).last)
  end

  test "should show conference" do
    get conference_url(@conference)
    assert_response :success
  end

  test "should get edit" do
    get edit_conference_url(@conference)
    assert_response :success
  end

  test "should update conference" do
    patch conference_url(@conference), params: {conference: attributes_for(:conference)}
    assert_redirected_to conference_url(@conference)
  end
end
