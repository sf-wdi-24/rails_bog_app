Rails.application.routes.draw do
  root to: "creatures#index"

  resources :creatures, only: [:index, :new, :create, :show]
end