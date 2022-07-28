# TODO: authenticate users with API Keys | Social networks | Cognito

# TODO: API could store "coordenates"
#  - Then "replay mouse movement" functionality can be built on top
#  - Then "heatmap" generation functionality can be built on top

module V1
  class ActionColorsController < ApplicationController

    before_action :assign_user_id

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

      render json: { results: results }
    end

    def create
      Karafka.producer.produce_async(
        topic: "action_colors",
        payload: {
          user_id: assign_user_id,
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
      params.require(:action_color).permit(:user_id, :action_name, :color_name)
    end

    def assign_user_id
      @assign_user_id ||= SecureRandom.uuid
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
      @colors ||= Color.all.pluck(:name).sort
    end
  end
end
