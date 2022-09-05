class Order

  def self.fetch_orders
    
    all_orders = ShopifyAPI::Order.find(:all, params: { fulfillment_status: 'any', limit: 250 })

    @page_count = 0
    @order_count = 0
    create_orders(all_orders)
    while all_orders.next_page?
      @page_count += 1
      all_orders = all_orders.fetch_next_page
      create_orders(all_orders)
    end

  end

  def self.create_orders(all_orders)
    for shopify_order in all_orders
      @order_count += 1
      order = ShopifyOrder.find_by_number shopify_order.number
      unless order
        order = ShopifyOrder.new

        order.email = shopify_order.email
        order.number = shopify_order.number
        order.shopify_id = shopify_order.id
        order.order_status_url = shopify_order.order_status_url
        if order.save
          Colorize.green "saved order #{order.number}; page: #{@page_count} order: #{@order_count}"
        else
          puts Colorize.red "#{order.error}; page: #{@page_count} order: #{@order_count}"
        end
      else
        puts Colorize.cyan "#{order.number} already exists; page: #{@page_count} order: #{@order_count}"
      end
    end
  end

end