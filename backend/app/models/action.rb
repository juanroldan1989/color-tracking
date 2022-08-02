class Action < ApplicationRecord
  validates :name, uniqueness: true
end
