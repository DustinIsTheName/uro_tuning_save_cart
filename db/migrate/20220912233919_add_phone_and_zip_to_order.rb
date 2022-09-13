class AddPhoneAndZipToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :shopify_orders, :zip, :string
    add_column :shopify_orders, :phone, :string
  end
end
