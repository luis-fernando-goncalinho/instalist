Rails.application.routes.draw do
  devise_for :user, controllers: { registrations: 'users/registrations' }
  root to: "lists#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :lists do
    resources :items, only: [:create]
    resources :favorites, only: [:create, :destroy, :show]
  end

  resources :items, only: [:destroy]
  resources :favorites, only: [:destroy, :index]

  get '/my_lists', to: "lists#my_lists"
  get '/all_lists', to: "lists#all_lists"
  get '/auth', to: "lists#auth"
end
