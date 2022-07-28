class ActionColor < ApplicationRecord
  belongs_to :action
  belongs_to :color

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
    # increment amount for the right color
    last_amount = ActionColor.by_color_id(self.color_id).maximum(:amount)
    self.amount = last_amount.to_i + 1
  end
end
