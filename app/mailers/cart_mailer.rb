class CartMailer < ApplicationMailer

  default to: 'dustin@wittycreative.com'

  def save_cart_email(params)
    @cart = params["cart"]

    @items = @cart["items"]

    if params["email"]
      email = params["email"]
    else
      email = 'dustin@wittycreative.com'
    end

    for i in 0..@items.length - 1
      puts Colorize.orange("item " + i.to_s)

      puts @items[i.to_s]["image"]
    end

    mail(to: email, from: 'support@urotuning.com', subject: 'Your Saved Cart')
  end

end