Rails.application.routes.draw do
  get 'creatures/index'

  get 'creatures/show'

  get 'creatures/new'

  get 'creatures/create'

  get 'creatures/edit'

  get 'creatures/update'

  get 'creatures/destroy'

  root 'creatures#index'
  resources :creatures
  
end
