module V1
  class ActionColorsController < ApplicationController

    before_action :assign_user_id

    def index
      records = ActionColor.by_action(index_params[:action_name])

      render json: {
        results: [
          {
            "action" => "hover",
            "color" => "red",
            "amount" => "236"
          },
          {
            "action" => "hover",
            "color" => "blue",
            "amount" => "120"
          },
          {
            "action" => "hover",
            "color" => "yellow",
            "amount" => "250"
          },
          {
            "action" => "hover",
            "color" => "green",
            "amount" => "780"
          }
        ]
      }
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
  end
end
