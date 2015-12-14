Rails.application.routes.draw do
  root "creatures#index"

  resources :creatures
end
