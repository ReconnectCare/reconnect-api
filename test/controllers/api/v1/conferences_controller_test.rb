require "test_helper"

class ConferencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    create(:conference_number)
  end

  test "create - error w/out params" do
    token = create(:api_token)
    user = token.user

    params = {
      patient: {bad: :param}
    }
    post api_v1_conferences_url, headers: {Authorization: "Bearer #{user.api_tokens.first.token}"}, params: params

    assert_response :unprocessable_entity

    assert_equal "patient", response.parsed_body["message"]
  end

  test "create" do
    token = create(:api_token)
    user = token.user

    params = {
      external_id: "my_external_id",
      patient: attributes_for(:patient)
    }

    assert_difference("Conference.count") do
      post api_v1_conferences_url, headers: {Authorization: "Bearer #{user.api_tokens.first.token}"}, params: params
    end

    assert_response :success

    assert Patient.find_by(external_id: params.dig(:patient, :external_id))

    assert_equal "+13035550000", response.parsed_body.dig("conference_number", "number")

    # TODO: check rest of json pp response.parsed_body

    conference = Conference.order(created_at: :asc).last

    assert_equal "my_external_id", conference.external_id
  end

  test "create - existing patient" do
    fail "IMPL"
  end

  test "create - no available numbers" do
    fail "IMPL"
  end
end
