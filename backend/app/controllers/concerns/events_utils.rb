module EventsUtils
  extend ActiveSupport::Concern

  # The code inside the included block is evaluated
  # in the context of the class that includes the Visible concern.
  # You can write class macros here, and
  # any methods become instance methods of the including class.
  included do
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

    def action_title
      params.dig("action_color", "action_name") || params.dig("action_name")
    end

    def kafka_payload
      if ENV["REDIS_AS_DB"] == "true"
        # payload formatted for Redis
        {
          api_key: @user.api_key,
          action_name: action_title,
          color_name: create_params["color_name"]
        }
      else
        # payload formatted for Postgres
        {
          api_key: @user.api_key,
          action_id: action_id,
          color_id: color_id
        }
      end
    end

    def redis
      @redis ||= Redis.new(host: "redis")
    end

    def stream
      case action_title
      when Action::CLICK
        ClicksChannel::STREAM
      when Action::HOVER
        HoversChannel::STREAM
      end
    end

    def topic
      case action_title
      when Action::CLICK
        "click_on_colors"
      when Action::HOVER
        "hover_on_colors"
      end
    end
  end

  # The methods added inside the class_methods block (or, ClassMethods module)
  # become the class methods on the including class.
  class_methods do
  end
end
