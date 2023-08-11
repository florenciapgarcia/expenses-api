Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # TODO: - be specific about routes (narrow them down - only implemented ones)
  resources :users do
    resources :expenses
  end

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
