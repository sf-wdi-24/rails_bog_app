Rails.application.routes.draw do
  root "creatures#index"

  # use the resources method to have Rails make an index route for creatures
  resources :creatures, only: [:index, :new, :create, :show]

  # resources :creatures, only: [:index] is equivalent to:
  # get "/creatures", to: "creatures#index"
  # get "/creatures/new", to: "creatures#new"
   # post "/creatures", to: "creatures#create"
   # post "/creatures/:id", to: "creatures#show"



end
