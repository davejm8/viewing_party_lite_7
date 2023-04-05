# frozen_string_literal: true

Rails.application.routes.draw do
  root 'landing#index'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  resources :users, only: [:show] do
    resources :movies, only: [:show] do
      resources :viewing_parties, only: %i[new create]
    end
  end

  get "/login", to: "users#login_form"
  post "/login", to: "users#login_user"
  get "/logout", to: "users#logout_user"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # get 'users/:id', to: "users#show"
  get "/users/:user_id/movies/:movie_id/viewing_party/new", to: "viewing_parties#new"
  
  get "/users/:id/discover", to: "user_discovers#index"

  get "/users/:id/movies", to: "user_movies#index"
end
