class ProductsController < ApplicationController
  def index
    @books = Book.all
    render layout: 'product'
  end

  def about
    render layout: 'product'
  end
end
