Rails.application.routes.draw do
  resources :line_items, only: [:create]
  resources :carts,  only: [:create, :show, :destroy]
  resources :orders, only: [:new, :create]
  resources :musics
  resources :orders_management, only: [:index, :edit] do
    put :confirm_payment
    put :deliver
  end
  get 'products/index'
  get 'about', to: 'products#about'

  devise_for :users
  root to: 'products#index'

  resources :users
  resources :tags, except: :show
  resources :books do
    resources :taggings, only: [:new, :edit, :create, :update, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
