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
  has_one :order_detail
  after_commit :send_order_mail, on: :create
  
  def checkout(cart)
    cart.line_items.each do |line_item|
      line_item.quantity.times do |_i| 
        build_order_detail(product_id: line_item.product_id)
      end
    end
    save!
  end
  
private

  def send_order_mail
    OrderMailer.completed_mail(self).deliver
  end
  
end
