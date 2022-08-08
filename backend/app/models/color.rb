class Color < ApplicationRecord
  validates :name, uniqueness: true
end
