class OrderController < ApplicationController

  skip_before_action :verify_authenticity_token

  def new_order
    # puts params

    is_presant = ShopifyOrder.find_by_number params["number"]
    if is_presant
      puts Colorize.cyan "#{params["name"]} Already exists"
    else
      order = ShopifyOrder.new

      order.email = params["email"]
      if params["customer"]
        if params["customer"]["default_address"]
          order.phone = params["customer"]["default_address"]["phone"]&.gsub(/[\s\(\)\-\+]/, "")
          order.zip = params["customer"]["default_address"]["zip"]
        end
      end
      order.number = params["name"]
      order.shopify_id = params["id"]
      order.order_status_url = params["order_status_url"]
      order.save
      puts Colorize.green "#{params["name"]} saved"
    end

    head :ok
  end

  def fetch_order
    headers['Access-Control-Allow-Origin'] = '*'
    # puts params

    order = ShopifyOrder.find_by_number params["order_number"]

    order_status_url = false
    if order
      puts order.email
      puts order.zip
      puts order.phone
      if order.email&.downcase == params["order_email"]&.downcase or order.zip == params["order_email"] or order.phone == params["order_email"]&.gsub(/[\s\(\)\-\+]/, "")
        order_status_url = order.order_status_url
      end
    end

    render json: {order_status_url: order_status_url}
  end

  def sync_orders
    # puts params

    Order.fetch_orders

    render json: params
  end

  def fulfill
    for line_item in params["line_items"]
      if line_item["fulfillment_status"] == "fulfilled"

        remove_metafields(line_item["product_id"], line_item["variant_id"])
        remove_eta_from_ordoro_product(line_item["product_id"], line_item["variant_id"])
    
      else
        puts Colorize.cyan "fulfillment_status is #{line_item["fulfillment_status"]}"
      end
    end

    head :ok
  end

  def check_inventory
    for variant in params["variants"]
      if variant["inventory_quantity"] > 0
        remove_metafields(params["id"], variant["id"])
        remove_eta_from_ordoro_product(params["id"], variant["id"])
      else
        puts Colorize.cyan "variant has 0 inventory"
      end
    end

    head :ok
  end

  def remove_metafields(product_id, variant_id)
    product = ShopifyAPI::Product.find product_id
    if product.variants.count > 1
      variant = product.variants.select {|v| v.id == variant_id}.first

      variant_metafields = variant.metafields

      oos = variant_metafields.select{|m| m.namespace == "global" and m.key == "OOS-Note" }.first
      eta = variant_metafields.select{|m| m.namespace == "global" and m.key == "ETA" }.first

      if oos
        oos.destroy
        puts Colorize.green "Variant #{oos.namespace}.#{oos.key}: #{oos.value}"
      else
        puts Colorize.cyan "Variant oos not found"
      end

      if eta
        eta.destroy
        puts Colorize.green "Variant #{eta.namespace}.#{eta.key}: #{eta.value}"
      else
        puts Colorize.cyan "Variant eta not found"
      end
    else
      product_metafields = product.metafields

      oos = product_metafields.select{|m| m.namespace == "global" and m.key == "OOS-Note" }.first
      eta = product_metafields.select{|m| m.namespace == "global" and m.key == "ETA" }.first

      if oos
        oos.destroy
        puts Colorize.green "Product #{oos.namespace}.#{oos.key}: #{oos.value}"
      else
        puts Colorize.cyan "Product oos not found"
      end

      if eta
        eta.destroy
        puts Colorize.green "Product #{eta.namespace}.#{eta.key}: #{eta.value}"
      else
        puts Colorize.cyan "Product eta not found"
      end
    end
  end

  def remove_eta_from_ordoro_product(product_id, variant_id)
    product = ShopifyAPI::Product.find product_id

    variant = product.variants.select {|v| v.id == variant_id}.first
    sku = variant.sku || variant.id

    OrdoroProduct.rm_eta_from_title(sku)
    
  end

end






















