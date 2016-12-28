class Product < ApplicationRecord
  has_many :order_details
  has_many :line_items

  scope :books,  ->(){ where(type: "Book") }
  scope :musics, ->(){ where(type: "Music") }
  scope :visible, ->(){ where(showing: true) }
end
