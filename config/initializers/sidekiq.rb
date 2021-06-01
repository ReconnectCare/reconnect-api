Sidekiq.configure_server do |config|
  config.redis = {url: Rails.application.credentials.dig(:redis, :url) || "redis://localhost:6379/1"}

  if Rails.env != "development"
    config.logger.level = Logger::WARN
  end

  config.on(:startup) do
    ActiveRecord::Base.clear_active_connections!
  end

  config.death_handlers << lambda do |worker, ex|
    ExceptionNotifier.notify_exception(
      ex,
      data: {worker: worker.to_s}
    )
  end
end

Sidekiq.configure_client do |config|
  config.redis = {url: Rails.application.credentials.dig(:redis, :url) || "redis://localhost:6379/1"}
end
