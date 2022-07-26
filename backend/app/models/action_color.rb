class ActionColor < ApplicationRecord

  before_save :set_amount

  private

  def set_amount
    last_amount = ActionColor.maximum(:amount)
    self.amount = last_amount.to_i + 1
  end
end
