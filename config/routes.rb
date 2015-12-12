Rails.application.routes.draw do
  root to: "creatures#index"

  resources :creatures

  # or
  # resources :creatures, only: [:index, :new, :create, :show, :edit, :update, :destroy] is equivalent to:
  
  # or
  # get "/creatures", to: "creatures#index"
  # get "/creatures/new", to: "creatures#new"
  # post "/creatures", to: "creatures#create"
  # get "/creatures/:id", to: "creatures#show"
  # get "/creatures/:id/edit", to: "creatures#edit"
  # put "/creatures/:id", to: "creatures#update"
  # patch "/creatures/:id", to: "creatures#update"
  # delete "/creatures/:id", to: "creatures#destroy"

end
