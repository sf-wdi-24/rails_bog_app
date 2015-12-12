Rails.application.routes.draw do
  root "creatures#index"

  # use the resources methody to have Rails make an index route for creatues
  resources :creatures, only: [:index]
 
end
