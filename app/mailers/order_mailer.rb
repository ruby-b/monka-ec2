class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.completed_mail.subject
  #
  def completed_mail(order)
    @order = order
    mail to: order.user.email, subject: 'ご注文完了のお知らせ'
  end
end
