class OrdersMailer < ApplicationMailer
  def confirmed_order(order_id)
    @order = Order.eager_load(line_items: [:product]).find(order_id)
    mail(to: @order.user.email, subject: "Your order is ready!")
  end
end
