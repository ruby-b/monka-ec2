# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/completed_mail
  def completed_mail
    OrderMailerMailer.completed_mail
  end

end
