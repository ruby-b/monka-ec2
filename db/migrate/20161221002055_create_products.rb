class CreateProducts < ActiveRecord::Migration[5.0]
  def up
    create_table :products do |t|
      t.string :type
      t.string :title
      t.string :author
      t.date :published_on
      t.boolean :showing
      t.integer :price

      t.timestamps
    end
    
    books = Book.all
    books.each do |book|
      product = Product.new(book.attributes)
      product.type = 'Book'
      product.save
    end
  end
  
  def down
    drop_table :products  
  end
end
