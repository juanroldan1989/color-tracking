# TODO: add unique clause inside DB too
class Color < ApplicationRecord
  validates :name, uniqueness: true
end
