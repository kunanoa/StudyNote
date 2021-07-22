Rails.application.routes.draw do
  get 'home/index'
  get 'container/index'
  get 'container/new'
  post 'container/create'
  get 'container/run'
  get 'container/delete'
  get 'images/index'
  get 'images/new'
  post 'images/create'
  get 'images/delete'
  get 'images/delete_2'

  devise_for :users

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
