# frozen_string_literal: true

class Action < ApplicationRecord
  CLICK = "click"
  HOVER = "hover"

  validates :name, uniqueness: true
end
