class ProvidersController < ApplicationController
  load_and_authorize_resource

  # GET /providers or /providers.json
  def index
    @pagy, @providers = pagy(@providers.order(name: :asc))
  end

  # GET /providers/1 or /providers/1.json
  def show
  end

  # GET /providers/new
  def new
  end

  # GET /providers/1/edit
  def edit
  end

  # POST /providers or /providers.json
  def create
    @provider = Provider.new(provider_params)

    respond_to do |format|
      if @provider.save
        format.html { redirect_to @provider, notice: "Provider was successfully created." }
        format.json { render :show, status: :created, location: @provider }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /providers/1 or /providers/1.json
  def update
    respond_to do |format|
      if @provider.update(provider_params)
        format.html { redirect_to @provider, notice: "Provider was successfully updated." }
        format.json { render :show, status: :ok, location: @provider }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /providers/1 or /providers/1.json
  def destroy
    @provider.destroy
    respond_to do |format|
      format.html { redirect_to providers_url, notice: "Provider was successfully destroyed." }
      format.json { head :no_content }
    end
  rescue ActiveRecord::InvalidForeignKey
    respond_to do |format|
      format.html { redirect_to providers_url, alert: "Can't destory, has dependent data." }
      format.json { render json: {error: "Can't destory, has dependent data."} }
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def provider_params
    params.require(:provider).permit(:external_id, :name, :phy_code, :cell_phone)
  end
end
