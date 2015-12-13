Rails.application.routes.draw do
	root "creatures#index"

  # use the resources method to have Rails make an index route for creatures
  resources :creatures, only: [:index, :new, :create, :show]

end
