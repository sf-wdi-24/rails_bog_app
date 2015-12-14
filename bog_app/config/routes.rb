Rails.application.routes.draw do
  root "creatures#index"

  resources :creatures, only: [:index, :new, :create, :show]
end
