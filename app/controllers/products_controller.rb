class ProductsController < ApplicationController
  before_action :set_book, only: [:show]
  
  def index
    @books = Book.visible.all
    @musics = Music.visible.all
    render layout: 'front'
  end

  def show
    render layout: 'front'
  end

  def about
    render layout: 'front'
  end
  
private
  
  def set_book
    @product = Product.find(params[:id])
  end
    
end
