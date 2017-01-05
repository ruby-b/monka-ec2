class ProductsController < ApplicationController
  
  def index
    @cart = current_cart
    @product  = Product.ransack(params[:q])
    products  = @product.result.visible
    @books    = products.books
    @musics   = products.musics
    render layout: 'front'
  end

  def about
    render layout: 'front'
  end

end
