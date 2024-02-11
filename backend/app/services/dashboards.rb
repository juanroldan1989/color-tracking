class Dashboards
  # TODO: implement with Rising Wave
  def self.results(api_key:, action_name: nil)
    Colors.list.map do |color|
      records = ActionColor.includes(:action).includes(:color).
        by_api_key(api_key).
        by_color(color)

      records = records.by_action(action_name) if action_name.present?

      next unless records.present?

      {
        "action" => records.last.action.name,
        "color"  => color,
        "amount" => records.maximum(:amount)
      }
    end.compact
  end

  def self.results_from_redis(api_key:, action_name:, redis: nil)
    Colors.list.map do |color_name|
      key = "#{api_key}_#{action_name}_#{color_name}"
      value = redis.get(key).to_i

      next unless value.positive?

      {
        "action" => action_name,
        "color" => color_name,
        "amount" => value
      }
    end
  end
end
