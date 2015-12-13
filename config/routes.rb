Rails.application.routes.draw do
	root to: "creatures#index"

  # use the resources method to have Rails make an index route for creatures
  # resources :creatures, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  resources :creatures
end
