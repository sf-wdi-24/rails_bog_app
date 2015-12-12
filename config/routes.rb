Rails.application.routes.draw do
  root to: "creatures#index"

  # use the resources method to have Rails make an default routes for creatues
  resources :creatures
 
end
