class Order < ApplicationRecord
  include AASM
  
  enum status: { order_accepted: 0, paid: 1, delivered: 2 }
  
  aasm column: :status do
    state :order_accepted, initial: true
    state :paid
    state :delivered
    
    event :confirm_payment do
      transitions from: :order_accepted, to: :paid
    end
    
    event :deliver do
      transitions from: :paid, to: :delivered
    end
  end
  
  belongs_to :user
  has_many :order_details
  after_commit :send_order_mail, on: :create
  
  def checkout(cart)
    cart.line_items.each do |line_item|
      order_details.build(product_id: line_item.product_id, quantity: line_item.quantity)
    end
    save!
  end

  def total_price
    order_details.to_a.sum { |item| item.total_price }
  end

  def total_number
    order_details.to_a.sum { |item| item.quantity }
  end

private

  def send_order_mail
    OrderMailer.completed_mail(self).deliver
  end
  
end
