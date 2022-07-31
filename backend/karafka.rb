# frozen_string_literal: true

# TODO: when setting up docker-compose, try edenhill/kafkacat:latest

require ::File.expand_path('../config/environment', __FILE__)

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka = { 'bootstrap.servers': '127.0.0.1:9092' }
    config.client_id = 'example_app'
    config.concurrency = 5
    # Recreate consumers with each batch. This will allow Rails code reload to work in the
    # development mode. Otherwise Karafka process would not be aware of code changes
    config.consumer_persistence = !Rails.env.development?
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  routes.draw do
    # Uncomment this if you use Karafka with ActiveJob
    # You ned to define the topic per each queue name you use
    # active_job_topic :default

    topic :click_on_colors do
      consumer ClicksConsumer
    end

    topic :hover_on_colors do
      consumer HoversConsumer
    end
  end
end
