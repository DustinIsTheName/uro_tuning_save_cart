class OrderController < ApplicationController

  skip_before_action :verify_authenticity_token

  def new_order
    puts params

    is_presant = ShopifyOrder.find_by_number params["number"]
    if is_presant
      puts Colorize.cyan "#{params["number"]} Already exists"
    else
      order = ShopifyOrder.new

      order.email = params["email"]
      if params["customer"]
        if params["customer"]["default_address"]
          order.phone = params["customer"]["default_address"]["phone"]&.gsub(/[\s\(\)\-\+]/, "")
          order.zip = params["customer"]["default_address"]["zip"]
        end
      end
      order.number = params["number"]
      order.shopify_id = params["id"]
      order.order_status_url = params["order_status_url"]
      order.save
      puts Colorize.green "#{params["number"]} saved"
    end

    head :ok
  end

  def fetch_order
    headers['Access-Control-Allow-Origin'] = '*'
    puts params

    order = ShopifyOrder.find_by_number params["order_number"]

    order_status_url = false
    if order
      puts order.email
      puts order.zip
      puts order.phone
      if order.email == params["order_email"] or order.zip == params["order_email"] or order.phone == params["order_email"]&.gsub(/[\s\(\)\-\+]/, "")
        order_status_url = order.order_status_url
      end
    end

    render json: {order_status_url: order_status_url}
  end

  def sync_orders
    puts params

    Order.fetch_orders

    render json: params
  end

end