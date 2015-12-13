Rails.application.routes.draw do

  root "creatures#index"
  resources :creatures, only: [:index, :new, :create, :show, :edit, :update]


	 #get "/creatures", to: "creatures#index" -- (view:index, shows all creatures)
	 #get "/creatures/new", to: "creatures#new" -- (view:new, shows form to create new creature)
	 #post "/creatures", to: "creatures#create" -- (add new creature to db)
	 #get "/creatures/:id", to: ":creatures#show" -- (view:show, show one creature)
	 #get "/creatures/:id/edit", to: "creatures#edit" -- (view:edit, show form to edit one creature)
	 #put "/creatures/:id", to: "creatures#update" -- (update one creature in db)
	 #delete "/creatures/:id", to: "creatures#destroy" -- (destroy one creature in db)

end
