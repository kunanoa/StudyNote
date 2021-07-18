Rails.application.routes.draw do
  get 'images/index'
  get 'container/index'
  get 'container/run'
  get 'container/delete'
  get 'home/index'
  get 'images/index'
  devise_for :users

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
