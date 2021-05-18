class Api::V1::MeController < Api::ApiController
  authorize_resource class: false

  def show
    render partial: "users/user", locals: {user: current_user}
  end
end
