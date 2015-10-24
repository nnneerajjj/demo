Rails.application.routes.draw do
  resources :purchases
  resources :products
  resources :categories
  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users, :controllers => { :registrations => "users/registrations" }
  resources :users
end
