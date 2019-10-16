Rails.application.routes.draw do


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/privacy", to: "static_pages#privacy"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  post "/oauth/:provider", to: "oauths#create", as: :oauth

  resources :users do
    member do
      get :following, to: "relationships#index", relationship: :following
      get :followers, to: "relationships#index", relationship: :followers
    end
  end
  
  resources :posts, only: [:create, :destroy, :show] do
    member do
      patch :like, to: "likes#update"
      post :comment, to: "comments#create"
      post :share, to: "shares#create"
    end
  end

  resources :account_activations, only: :edit
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :relationships, only: [:create, :destroy]
  # resources :notifications, only: [:index, :update, :show]
  get "/notifications", to: "notifications#index"
  get "/notifications/show", to: "notifications#show"
  patch "/notifications/update", to: "notifications#update"
end
