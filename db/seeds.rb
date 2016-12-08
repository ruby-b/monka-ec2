# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

CSV.foreach('db/tags.csv', headers: :first_row) do |row|
  tag = Tag.find_or_create_by(name: row['name'])
end

CSV.foreach('db/books.csv', headers: :first_row) do |row|
  book              = Book.find_or_create_by(title: row['title'], author: row['author'], price: row['price'], showing: row['showing'])
  book.published_on = Date.parse(row['published_on'])
  book.save

  unless row['tag_name1'].blank?
    tag     = Tag.where(name: row['tag_name1']).first
    tagging = Tagging.find_or_create_by(book_id: book.id, tag_id: tag.id)
  end

  unless row['tag_name2'].blank?
    tag     = Tag.where(name: row['tag_name2']).first
    tagging = Tagging.find_or_create_by(book_id: book.id, tag_id: tag.id)
  end
end

admin = User.where(email: 'test@example.com')
unless admin.present?
  User.create(name: 'Admin', email: 'test@example.com', password: 'monka_project', password_confirmation: 'monka_project', role: 'admin')
end
