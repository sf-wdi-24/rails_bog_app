Rails.application.routes.draw do
  root to: "creatures#index"

  # use the resources method to have Rail make an index route for creatures
  resources :creatures, only: [:index, :new, :create, :show]
  # same as:   get"/creatures", to: "creatures#index"

end
