Rails.application.routes.draw do

  get 'users/new'

  get 'users/create'

  root 'creatures#index'
  resources :creatures

  get 'signup' => 'users#new'
  post '/users' => 'users#create'
  
end
