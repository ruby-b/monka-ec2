class AddQuantityToOrderDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :order_details, :quantity, :integer, default:1
  end
end
