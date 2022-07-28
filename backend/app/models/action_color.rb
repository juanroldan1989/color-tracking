class ActionColor < ApplicationRecord
  belongs_to :action
  belongs_to :color

  scope :by_action, -> (action_name) {
    joins(:action).where(actions: { name: action_name })
  }

  before_save :set_amount

  private

  def set_amount
    last_amount = ActionColor.maximum(:amount)
    self.amount = last_amount.to_i + 1
  end
end
