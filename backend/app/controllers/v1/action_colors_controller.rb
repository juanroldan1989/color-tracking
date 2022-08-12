module V1
  class ActionColorsController < ApplicationController
    include CableReady::Broadcaster

    # TODO: implement ElasticSearch for indexing data
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

      cable_ready["live_dashboards"].console_log(message: { results: results })
      cable_ready.broadcast
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
      @colors ||= Colors.list
    end

    def topic
      case create_params["action_name"]
      when "hover"
        "hover_on_colors"
      when "click"
        "click_on_colors"
      end
    end

    def results
      Dashboards.results(
        api_key: @user.api_key,
        action_name: index_params["action_name"]
      )
    end
  end
end
