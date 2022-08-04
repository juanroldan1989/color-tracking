# TODO: API could store "coordenates"
#  - Then "replay mouse movement" functionality can be built on top
#  - Then "heatmap" generation functionality can be built on top
#  - Then "live mouse movements" could be replicated in an Admin Dashboard
#    having an endpoint reading from Kafka and sending live data via websockets

module V1
  class ActionColorsController < ApplicationController

    def index
      results = colors.map do |color|
        records = ActionColor.includes(:action).includes(:color).
          by_api_key(@user.api_key).
          by_color(color)

        if index_params["action_name"].present?
          records = records.by_action(index_params["action_name"])
        end

        record = records.last

        next unless record.present?

        {
          "action" => record.action.name,
          "color"  => color,
          "amount" => records.maximum(:amount)
        }
      end

      render json: { results: results.compact }
    end

    def create
      # Karafka.producer.produce_async(topic: "hover_on_colors", payload: { api_key: "testing", action_id: Action.first.id, color_id: Color.first.id }.to_json)
      Karafka.producer.produce_async(
        topic: topic,
        payload: {
          api_key: @user.api_key,
          action_id: action_id,
          color_id: color_id
        }.to_json
      )
    end

    private

    def index_params
      params.permit(:action_name)
    end

    def create_params
      params.require(:action_color).permit(:action_name, :color_name)
    end

    def action_id
      Action.find_by_name(create_params["action_name"]).id
    rescue
      Action.first.id
    end

    def color_id
      Color.find_by_name(create_params["color_name"]).id
    rescue
      Color.first.id
    end

    def colors
      @colors ||= Color.select(:name).pluck(:name).sort
    end

    def topic
      case create_params["action_name"]
      when "hover"
        "hover_on_colors"
      when "click"
        "click_on_colors"
      end
    end
  end
end
