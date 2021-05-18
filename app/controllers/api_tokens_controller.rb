class ApiTokensController < ApplicationController
  load_and_authorize_resource

  # GET /api_tokens or /api_tokens.json
  def index
  end

  # GET /api_tokens/1 or /api_tokens/1.json
  def show
  end

  # GET /api_tokens/new
  def new
  end

  # GET /api_tokens/1/edit
  def edit
  end

  # POST /api_tokens
  def create
    @api_token = ApiToken.new(api_token_params.merge(user: current_user)).make_token

    if @api_token.save
      redirect_to @api_token, notice: "Api token was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api_tokens/1
  def update
    if @api_token.update(api_token_params)
      redirect_to @api_token, notice: "Api token was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /api_tokens/1
  def destroy
    @api_token.delete!
    redirect_to api_tokens_url, notice: "Api token was successfully destroyed."
  end

  private

  # Only allow a list of trusted parameters through.
  def api_token_params
    params.require(:api_token).permit(:name)
  end
end
