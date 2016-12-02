class ProductsController < ApplicationController
  def index
    @books = Book.visible.all
    render layout: 'product'
  end

  def about
    render layout: 'product'
  end
end
