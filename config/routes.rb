Rails.application.routes.draw do

  root 'creatures#index'
  resources :creatures

  get 'signup' => 'users#new'
  post '/users' => 'users#create'
  
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'

end
