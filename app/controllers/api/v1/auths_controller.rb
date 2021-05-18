class Api::V1::AuthsController < Api::ApiController
  skip_authorization_check

  # Requires email and password params, accepts a name parameter
  # Returns an API token for the user if valid
  def create
    user = User.find_by(email: auth_params[:email])
    if user&.valid_password?(auth_params[:password])
      @token = user.api_tokens.find_or_create_by(name: (auth_params[:name] || "default")) do |token|
        token.make_token.save!
      end
      render json: {
        token: @token.token
      }
    else
      head :unauthorized
    end
  end

  private

  def auth_params
    params.permit(:email, :password, :name)
  end
end
