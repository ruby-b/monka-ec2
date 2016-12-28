class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product_id)
    current_item = line_items.find_or_create_by(id: product_id)
    current_item.quantity += 1
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  def total_number
    line_items.to_a.sum { |item| item.quantity }
  end

end
