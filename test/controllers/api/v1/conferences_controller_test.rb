require "test_helper"

class ConferencesControllerTest < ActionDispatch::IntegrationTest
  class PatientParamsConferencesControllerTest < ConferencesControllerTest
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
        reason: "health call",
        patient: attributes_for(:patient)
      }

      mock = Minitest::Mock.new
      def mock.get_available_providers state
        [OnDemandClient::Provider.new]
      end

      OnDemandClient.stub :new, mock do
        assert_difference("Conference.count" => 1, "SendPatientToOnDemandWorker.jobs.count" => 1) do
          post api_v1_conferences_url, headers: {Authorization: "Bearer #{user.api_tokens.first.token}"}, params: params
        end
      end

      assert_response :success

      assert Patient.find_by(external_id: params.dig(:patient, :external_id))

      assert_equal "+13035550000", response.parsed_body.dig("conference_number", "number")

      conference = Conference.order(created_at: :asc).last

      assert_equal "my_external_id", conference.external_id
    end

    test "create - existing patient" do
      token = create(:api_token)
      user = token.user

      patient_params = attributes_for(:patient)
      params = {
        external_id: "my_external_id",
        reason: "health call",
        patient: patient_params
      }

      assert Patient.create(patient_params)

      mock = Minitest::Mock.new
      def mock.get_available_providers state
        [OnDemandClient::Provider.new]
      end

      OnDemandClient.stub :new, mock do
        assert_difference "Conference.count" => 1, "Patient.count" => 0 do
          post api_v1_conferences_url, headers: {Authorization: "Bearer #{user.api_tokens.first.token}"}, params: params
        end
      end

      assert_response :success

      assert Patient.find_by(external_id: params.dig(:patient, :external_id))

      assert_equal "+13035550000", response.parsed_body.dig("conference_number", "number")

      conference = Conference.order(created_at: :asc).last

      assert_equal "my_external_id", conference.external_id
    end

    test "create - no available providers" do
      token = create(:api_token)
      user = token.user

      params = {
        external_id: "my_external_id",
        reason: "health call",
        patient: attributes_for(:patient)
      }

      mock = Minitest::Mock.new
      def mock.get_available_providers state
        []
      end

      OnDemandClient.stub :new, mock do
        assert_difference "Conference.count" => 0 do
          post api_v1_conferences_url, headers: {Authorization: "Bearer #{user.api_tokens.first.token}"}, params: params
        end
      end

      # Testing with assert_difference doesn't work consistently
      assert_equal 1, Patient.count

      assert_response :unprocessable_entity

      assert_equal "providers", response.parsed_body["message"]
      assert_equal "no available providers for CA.", response.parsed_body["errors"][0]
    end
  end

  class NumbersConferencesControllerTest < ConferencesControllerTest
    setup do
      @conference_number = create(:conference_number)
      @conference = create(:conference, conference_number: @conference_number)
    end

    test "create - error no available_numbers" do
      token = create(:api_token)
      user = token.user

      params = {
        external_id: "my_external_id",
        reason: "health call",
        patient: attributes_for(:patient)
      }
      post api_v1_conferences_url, headers: {Authorization: "Bearer #{user.api_tokens.first.token}"}, params: params

      assert_response :unprocessable_entity

      assert_equal "conference_number", response.parsed_body["message"]
      assert_equal "no available numbers.", response.parsed_body["errors"][0]
    end
  end
end
