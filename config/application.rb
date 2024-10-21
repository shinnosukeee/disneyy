require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module No
  class Application < Rails::Application
    config.load_defaults 7.2


    config.active_job.queue_adapter = :sidekiq
  end
end