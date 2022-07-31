class ActionColor < ApplicationRecord
  belongs_to :action
  belongs_to :color

  scope :by_api_key, -> (api_key) { where(api_key: api_key) }

  scope :by_action_id, -> (action_id) { where(action_id: action_id) }

  scope :by_action, -> (action_name) {
    joins(:action).where(actions: { name: action_name })
  }

  scope :by_color, -> (color_name) {
    joins(:color).where(colors: { name: color_name })
  }

  scope :by_color_id, -> (color_id) {
    joins(:color).where(colors: { id: color_id })
  }

  before_save :set_amount

  private

  def set_amount
    # find existing "api_key/action/color" combination
    # to return proper values for concurrent users consuming the API
    record = ActionColor.
             by_api_key(self.api_key).
             by_action_id(self.action_id).
             by_color_id(self.color_id).
             last

    self.amount = if record.present?
      record.amount + 1
    else
      1
    end
  end
end
