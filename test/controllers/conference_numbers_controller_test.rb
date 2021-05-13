require "test_helper"

class ConferenceNumbersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    sign_in @user.reload
    @conference_number = create(:conference_number)
  end

  test "should get index" do
    get conference_numbers_url
    assert_response :success
  end

  test "should get new" do
    get new_conference_number_url
    assert_response :success
  end

  test "should create conference_number" do
    assert_difference("ConferenceNumber.count") do
      post conference_numbers_url, params: {conference_number: attributes_for(:conference_number)}
    end

    assert_redirected_to conference_number_url(ConferenceNumber.order(created_at: :asc).last)
  end

  test "should show conference_number" do
    get conference_number_url(@conference_number)
    assert_response :success
  end

  test "should get edit" do
    get edit_conference_number_url(@conference_number)
    assert_response :success
  end

  test "should update conference_number" do
    patch conference_number_url(@conference_number), params: {conference_number: attributes_for(:conference_number)}
    assert_redirected_to conference_number_url(@conference_number)
  end

  test "should destroy conference_number" do
    assert_difference("ConferenceNumber.count", -1) do
      delete conference_number_url(@conference_number)
    end

    assert_redirected_to conference_numbers_url
  end
end
