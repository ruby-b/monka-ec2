class Product < ApplicationRecord
  scope :visible, ->(){ where(showing: true) }
end
