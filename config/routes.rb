Rails.application.routes.draw do
  root "creatures#index"

  # use the resources method to have Rails make an index route for creatures
  resources :creatures, only: [:index]

  # resources :creatures, only: [:index] is equivalent to:
  # get "/creatures", to: "creatures#index"
end
