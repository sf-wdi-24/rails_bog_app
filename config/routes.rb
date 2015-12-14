Rails.application.routes.draw do
  root "creatures#index"
  # use the resources method to have Rails make an index route for creatures
  resources :creatures, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  # resources :creatures, only: [:index, :new, :create, :show, :edit, :update, :destroy] is equivalent to:
  # get "/creatures", to: "creatures#index"
  # get "/creatures/new", to: "creatures#new"
  # post "/creatures", to: "creatures#create"
  # get "/creatures/:id", to: "creatures#show"
  # get "/creatures/:id/edit", to: "creatures#edit"
  # put "/creatures/:id", to: "creatures#update"
  # patch "/creatures/:id", to: "creatures#update"
  # delete "/creatures/:id", to: "creatures#destroy"

  # resources :creatures, only: [:index, :new, :create, :show] is equivalent to:
  # get "/creatures", to: "creatures#index"
  # get "/creatures/new", to: "creatures#new"
  # post "/creatures", to: "creatures#create"
  # post "/creatures/:id", to: "creatures#show"



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
