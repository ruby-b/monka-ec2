Rails.application.routes.draw do
  get 'products/index'
  get 'about', to: 'products#about'

  devise_for :users
  root to: 'products#index'

  resources :users
  resources :tags
  resources :books do
    resources :taggings
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
