class CartMailer < ApplicationMailer

  default to: 'dustin@wittycreative.com'

  def save_cart_email(params)
    unless params.class == Hash
      unsafe_params = params.to_unsafe_h
    end
    @cart = unsafe_params["cart"]
    @items = @cart["items"]
    trimmed_items = {"items" => {}}

    if unsafe_params["email"]
      @email = unsafe_params["email"]
    else
      @email = 'dustin@wittycreative.com'
    end

    for i in 0..@items.length - 1
      puts Colorize.orange("item " + i.to_s)

      puts @items[i.to_s]["image"]

      trimmed_items["items"][i.to_s] = {
        id: @items[i.to_s]["id"],
        quantity: @items[i.to_s]["quantity"],
        properties: @items[i.to_s]["properties"]
      }
    end

    puts Colorize.green(trimmed_items)

    @save_cart_url_params = Rack::Utils.build_nested_query(trimmed_items)

    puts Colorize.orange(@save_cart_url_params)

    mail(to: @email, from: 'support@urotuning.com', subject: 'Your Saved Cart')
  end

  def test_email(email)
    mail(to: email, from: 'support@urotuning.com', subject: 'Test Email')
  end

end