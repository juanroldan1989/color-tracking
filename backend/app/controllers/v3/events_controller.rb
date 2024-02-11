# API V3 Events Controller
# No events broker
# Events are stored in Redis
# ActionCable as broadcaster

# This controller handles "click" and "hover" events
# In the frontend: events are created when a user clicks or hovers over a color

module V3
  class EventsController < ApplicationController
    include EventsUtils

    # GET /v3/events
    # Given "api_key" and "action", returns the amount of clicks and hovers for each color from Redis
    # Endpoint for "polling" frontend script
    def index
      render json: { results: results }
    end

    # POST /v3/events
    # Events are stored in Redis
    def create
      key = "#{@user.api_key}_#{action_title}_#{create_params["color_name"]}"
      value = redis.get(key).to_i
      redis.set(key, value + 1)

      # Events are then broadcasted to the frontend via ActionCable
      # The frontend then updates the dashboard with the new events data
      ActionCable.server.broadcast stream, { results: results }
    end

    private

    def create_params
      params.require(:action_color).permit(:action_name, :color_name)
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
