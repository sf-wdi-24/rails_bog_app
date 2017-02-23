Rails.application.routes.draw do
  root to: "creatures#index"

  resources :creatures
end
