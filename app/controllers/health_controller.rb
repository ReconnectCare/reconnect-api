class HealthController < ApplicationController
  skip_authorization_check

  def check
    # TODO Database
    # TODO Redis

    status = 200

    sidekiq_ok, sidekiq_data = sidekiq

    status = 503 unless sidekiq_ok

    render status: status, json: {
      status: status,
      sidekiq: sidekiq_data
    }
  end

  private

  def sidekiq
    processes = Sidekiq::ProcessSet.new
    [processes.count > 0, processes]
  rescue => e
    [false, {
      message: e.message,
      backtrace: e.backtrace
    }]
  end
end
