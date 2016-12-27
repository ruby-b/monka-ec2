class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.belongs_to :user, foreign_key: true
      t.string :shipping_address
    
      t.timestamps
    end
  end
end
