class HealthController < ApplicationController
  skip_authorization_check

  def check
    status = 200

    redis_ok, redis_data = redis
    status = 503 unless redis_ok

    database_ok, database_data = database
    status = 503 unless database_ok

    sidekiq_ok, sidekiq_data = sidekiq
    status = 503 unless sidekiq_ok

    render status: status, json: {
      status: status,
      database_ok: database_ok,
      database: database_data,
      redis_ok: redis_ok,
      redis: redis_data,
      sidekiq_ok: sidekiq_ok,
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

  def database
    result = ActiveRecord::Base.connection.exec_query("SELECT 1 as OK;")
    [result.to_a.dig(0, "ok") == 1, result.to_a]
  rescue => e
    [false, {
      message: e.message,
      backtrace: e.backtrace
    }]
  end

  def redis
    redis_config = {url: Rails.application.credentials.dig(:redis, :url) || "redis://localhost:6379/1"}
    redis = Redis.new(redis_config)
    result = redis.hello
    [redis.ping == "PONG", redis.hello]
  rescue => e
    [false, {
      message: e.message,
      backtrace: e.backtrace
    }]
  end
end
