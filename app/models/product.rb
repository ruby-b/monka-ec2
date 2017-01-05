class Product < ApplicationRecord
  has_many :order_details
  has_many :line_items
  scope :visible, ->(){ where(showing: true) }
end
