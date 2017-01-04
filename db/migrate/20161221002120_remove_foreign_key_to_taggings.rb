class RemoveForeignKeyToTaggings < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :taggings, :books
  end
end
