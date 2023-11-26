# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
   config.logger = ActiveSupport::Logger.new(STDOUT)
  end
# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end
