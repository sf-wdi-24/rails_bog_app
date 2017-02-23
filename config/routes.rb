Rails.application.routes.draw do
  root "creatures#index"
  resources :creatures

  # use the resources method to have Rails make an index route for creatures
  resources :creatures, only: [:index, :new, :create, :show, :edit, :destroy]

  # resources :creatures, only: [:index] is equivalent to:
  # get "/creatures", to: "creatures#index"
  # get "/creatures/new", to: "creatures#new"
   # post "/creatures", to: "creatures#create"
   # post "/creatures/:id", to: "creatures#show"
   # get "/creatures/:id/edit", to: "creatures#edit"
   # put "/creatures/:id", to: "creatures#update"
  # patch "/creatures/:id", to: "creatures#update"
    # delete "/creatures/:id", to: "creatures#destroy"

end
