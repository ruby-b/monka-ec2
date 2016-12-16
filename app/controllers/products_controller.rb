class ProductsController < ApplicationController
  def index
    @books = Book.visible.all
    render layout: 'front'
  end

  def about
    render layout: 'front'
  end
end
