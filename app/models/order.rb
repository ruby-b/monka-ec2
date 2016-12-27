class Order < ApplicationRecord
  belongs_to :user
  has_one :order_detail
  after_commit :send_email, on: :create
end

private

  def send_email
    OrderMailer.completed_mail(self).deliver
  end