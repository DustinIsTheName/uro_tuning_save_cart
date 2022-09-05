task :sync_orders => :environment do |t, args|
  Order.fetch_orders
end