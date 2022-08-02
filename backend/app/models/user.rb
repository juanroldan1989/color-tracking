class User < ApplicationRecord
  validates :api_key, uniqueness: true
end
