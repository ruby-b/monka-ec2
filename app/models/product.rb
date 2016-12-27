class Product < ApplicationRecord
  has_many :order_details
  scope :visible, ->(){ where(showing: true) }
end
