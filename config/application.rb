require_relative "boot"

require "rails/all"

require 'sidekiq-scheduler'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WebOps
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    Sidekiq.configure_server do |config|
      config.on(:startup) do
        Sidekiq.schedule = YAML.load_file(File.expand_path('schedule.yml', __dir__))
        SidekiqScheduler::Scheduler.reload_schedule!
      end
    end
    
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
    config.session_store :cache_store, key: '_namespace_key', expire_after: 1.weeks

  end
end
