Rails.application.routes.draw do
  devise_for :user
    root to: "lists#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :lists do
    resources :items, only: [:create]
  end

  resources :items, only: [:destroy]
end
