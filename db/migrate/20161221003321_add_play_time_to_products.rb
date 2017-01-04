class AddPlayTimeToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :play_time, :integer
  end
end
