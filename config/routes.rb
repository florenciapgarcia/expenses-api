Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :expenses

  resources :users

  # TODO - make expenses live inside users!
  #  resources :users do
  #   resources :expenses
  # end

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
