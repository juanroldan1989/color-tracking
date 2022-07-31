# TODO: API could store "coordenates"
#  - Then "replay mouse movement" functionality can be built on top
#  - Then "heatmap" generation functionality can be built on top

module V1
  class ActionColorsController < ApplicationController

    def index
      results = colors.map do |color|
        record = ActionColor.includes(:action).by_color(color).last

        next unless record.present?

        {
          "action" => record.action.name,
          "color"  => color,
          "amount" => record.amount
        }
      end

      render json: { results: results.compact }
    end

    def create
      Karafka.producer.produce_async(
        topic: topic,
        payload: {
          api_key: @api_key,
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
