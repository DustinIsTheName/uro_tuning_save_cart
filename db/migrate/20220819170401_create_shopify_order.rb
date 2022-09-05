class CreateShopifyOrder < ActiveRecord::Migration[5.0]
  def change
    create_table :shopify_orders do |t|
      t.string :email
      t.string :number, index: { unique: true }
      t.string :shopify_id
      t.string :order_status_url

      t.timestamps
    end
  end
end
