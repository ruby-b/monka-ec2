Rails.application.routes.draw do
  resources :orders, only: [:new, :create]
  resources :musics
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
