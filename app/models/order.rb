class Order < ApplicationRecord
  belongs_to :user
  has_one :order_detail
  after_commit :send_order_mail, on: :create
  
  def checkout(product_id)
    build_order_detail(product_id: product_id)
    save!
  end
  
private

  def send_order_mail
    OrderMailer.completed_mail(self).deliver
  end
  
end

