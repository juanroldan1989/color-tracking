# API V1 Events Controller
# Kafka as events broker
# Consumers fetch events from Kafka topics and store them in Postgres
# ActionCable as broadcaster

# This controller handles "click" and "hover" events
# In the frontend: events are created when a user clicks or hovers over a color

module V1
  class EventsController < ApplicationController

    # GET /v1/events
    # Given "api_key" and "action", returns the amount of clicks and hovers for each color from Postgres
    # Endpoint for "polling" frontend script
    def index
      render json: { results: results }
    end

    # POST /v1/events
    # Events are sent to Kafka for further processing
    def create
      Karafka.producer.produce_async(
        topic: topic,
        payload: {
          api_key: @user.api_key,
          action_id: action_id,
          color_id: color_id
        }.to_json
      )

      # Events are then broadcasted to the frontend via ActionCable
      # The frontend then updates the dashboard with the new events data
      ActionCable.server.broadcast stream, { results: results }
    end

    private

    def create_params
      params.require(:action_color).permit(:action_name, :color_name)
    end

    def action_id
      Action.find_by_name(action_title).id
    rescue
      Action.first.id
    end

    def color_id
      Color.find_by_name(create_params["color_name"]).id
    rescue
      Color.first.id
    end

    def colors
      @colors ||= Colors.list
    end

    def topic
      case action_title
      when Action::CLICK
        "click_on_colors"
      when Action::HOVER
        "hover_on_colors"
      end
    end

    def action_title
      params.dig("action_color", "action_name") || params.dig("action_name")
    end

    def results
      Dashboards.results(
        api_key: @user.api_key,
        action_name: action_title
      )
    end

    def stream
      case action_title
      when Action::CLICK
        ClicksChannel::STREAM
      when Action::HOVER
        HoversChannel::STREAM
      end
    end
  end
end
