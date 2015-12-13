Rails.application.routes.draw do

  root "creatures#index"
  resources :creatures
=begin
  get "/creatures", to: "creatures#index"
  get "/creatures", to: "creatures#new"
  post "/creatures", to: "creatures#create"
  get "/creatures/:id", to: "creatures#show"
  get "/creatures/:id", to: "creatures#edit"
  put "/creatures/:id", to: "creatures#update"
  delete "/creatures/:id", to: "creatures#destroy"
=end



end
