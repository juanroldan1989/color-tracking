require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # TODO: validate this config when deploying to AWS
    # TODO: validate if the `cors.rb` file is needed
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        # origins 'http://example.com:80' / https://www.stackhawk.com/blog/rails-cors-guide/
        origins "*"
        resource "/v1/events",
          headers: :any,
          methods: [:get, :post]
          # if: proc { |env| env["HTTP_HOST"] == "api.example.com" }
      end
    end

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
