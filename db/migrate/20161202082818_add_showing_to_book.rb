class AddShowingToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :showing, :boolean, default: false
  end
end
