Rails.application.routes.draw do
  get 'images/index'
  get 'container/index'
  get 'container/new'
  post 'container/create'
  get 'container/run'
  get 'container/delete'
  get 'home/index'
  get 'images/index'
  get 'images/new'
  get 'images/delete'
  get 'images/delete_2'

  devise_for :users

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
