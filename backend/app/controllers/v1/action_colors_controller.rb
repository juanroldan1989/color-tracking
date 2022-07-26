module V1
  class ActionColorsController < ApplicationController

    before_action :assign_user_id

    def index
      render json: { data: ActionColor.all }
    end

    def create
      Karafka.producer.produce_async(topic: "action_colors", payload: { user_id: assign_user_id, action_id: 1, color_id: 2 }.to_json)
    end

    private

    def create_params
      params.require(:action_color).permit(:user_id, :action_name, :color_name)
    end

    def assign_user_id
      @assign_user_id ||= SecureRandom.uuid
    end

    def action_id
      Action.find_by_name(create_params[:action_color][:action_name])
    rescue
      Action.first.id
    end

    def color_id
      Color.find_by_name(create_params[:action_color][:color_name])
    rescue
      Color.first.id
    end
  end
end
