module V1
  class ActionColorsController < ApplicationController

    def index
      render json: { results: results }
    end

    def create
      Karafka.producer.produce_async(
        topic: topic,
        payload: {
          api_key: @user.api_key,
          action_id: action_id,
          color_id: color_id
        }.to_json
      )

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
