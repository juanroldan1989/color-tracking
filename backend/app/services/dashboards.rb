class Dashboards
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
end
