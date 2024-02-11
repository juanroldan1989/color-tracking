# API V2 Events Controller
# Kafka as events broker
# Consumers fetch events from Kafka topics and store them in Redis
# ActionCable as broadcaster

# This controller handles "click" and "hover" events
# In the frontend: events are created when a user clicks or hovers over a color

module V2
  class EventsController < ApplicationController
    include EventsUtils

    # GET /v2/events
    # Given "api_key" and "action", returns the amount of clicks and hovers for each color from Redis
    # Endpoint for "polling" frontend script
    def index
      render json: { results: results }
    end

    # POST /v2/events
    # Events are sent to Kafka for further processing
    def create
      Karafka.producer.produce_async(
        topic: topic,
        payload: kafka_payload.to_json
      )

      # Events are then broadcasted to the frontend via ActionCable
      # The frontend then updates the dashboard with the new events data
      ActionCable.server.broadcast stream, { results: results }
    end

    private

    def create_params
      params.require(:action_color).permit(:action_name, :color_name)
    end

    def redis
      @redis ||= Redis.new(host: "redis")
    end

    def results
      Dashboards.results_from_redis(
        api_key: @user.api_key,
        action_name: action_title,
        redis: redis
      )
    end
  end
end
