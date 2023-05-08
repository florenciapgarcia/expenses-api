Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :expenses

  resources :users

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end
