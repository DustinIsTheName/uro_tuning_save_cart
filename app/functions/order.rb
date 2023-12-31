class Order

  def self.fetch_orders
    
    all_orders = ShopifyAPI::Order.find(:all, params: { status: 'any', limit: 250 })

    @total_orders = ShopifyAPI::Order.count
    @total_pages = (@total_orders / 250.0).ceil

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
      order = ShopifyOrder.find_by_number shopify_order.name
      unless order
        order = ShopifyOrder.new

        order.email = shopify_order.email
        if shopify_order.attributes["customer"]
          if shopify_order.customer.attributes["default_address"]
            order.zip = shopify_order.customer.default_address.zip
            order.phone = shopify_order.customer.default_address.phone&.gsub(/[\s\(\)\-\+]/, "")
          end
        end
        order.number = shopify_order.name
        order.shopify_id = shopify_order.id
        order.order_status_url = shopify_order.order_status_url
        if order.save
          puts Colorize.green "saved order #{order.number}; page: #{@page_count}/#{@total_pages} order: #{@order_count}/#{@total_orders}"
        else
          puts Colorize.red "#{order.error}; page: #{@page_count}/#{@total_pages} order: #{@order_count}/#{@total_orders}"
        end
      else
        puts Colorize.cyan "#{order.number} already exists; page: #{@page_count}/#{@total_pages} order: #{@order_count}/#{@total_orders}"
      end
    end
  end

end