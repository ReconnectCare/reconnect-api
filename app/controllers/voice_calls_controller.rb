class VoiceCallsController < ApplicationController
  load_and_authorize_resource

  # GET /voice_calls or /voice_calls.json
  def index
    @pagy, @voice_calls = pagy(@voice_calls.includes(:conference).order(created_at: :desc))
  end

  # GET /voice_calls/1 or /voice_calls/1.json
  def show
  end

  # GET /voice_calls/new
  def new
  end

  # GET /voice_calls/1/edit
  def edit
  end

  # POST /voice_calls or /voice_calls.json
  def create
    @voice_call = VoiceCall.new(voice_call_params)

    respond_to do |format|
      if @voice_call.save
        format.html { redirect_to @voice_call, notice: "Voice call was successfully created." }
        format.json { render :show, status: :created, location: @voice_call }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @voice_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /voice_calls/1 or /voice_calls/1.json
  def update
    respond_to do |format|
      if @voice_call.update(voice_call_params)
        format.html { redirect_to @voice_call, notice: "Voice call was successfully updated." }
        format.json { render :show, status: :ok, location: @voice_call }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @voice_call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /voice_calls/1 or /voice_calls/1.json
  def destroy
    @voice_call.destroy
    respond_to do |format|
      format.html { redirect_to voice_calls_url, notice: "Voice call was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def voice_call_params
    params.require(:voice_call).permit(:provider_id, :conference_id, :direction, :status, :number)
  end
end
