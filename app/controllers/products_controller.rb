class ProductsController < ApplicationController
  def index
    @books = Book.all
    render layout: false
  end
end
