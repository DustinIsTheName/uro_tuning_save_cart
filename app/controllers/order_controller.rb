class OrderController < ApplicationController

  skip_before_action :verify_authenticity_token

  def new_order
    puts params

    order = ShopifyOrder.new

    order.email = params["email"]
    order.number = params["number"]
    order.shopify_id = params["id"]
    order.order_status_url = params["order_status_url"]
    order.save

    render nothing: true, status: 200
  end

  def fetch_order
    headers['Access-Control-Allow-Origin'] = '*'
    puts params

    order = ShopifyOrder.find_by_number params["order_number"]

    order_status_url = false
    if order
      order_status_url = order.order_status_url
    end

    render json: {order_status_url: order_status_url}
  end

  def sync_orders
    puts params

    Order.fetch_orders

    render json: params
  end

end