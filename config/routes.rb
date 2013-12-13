Beanbook::Application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :users, except: :destroy do
    resources :posts, except: [:index, :new]
    resources :friends, only: :index
    resources :friendships, only: [:create, :update, :destroy]
    resources :photos
    resources :tags, only: [:index, :create, :destroy]
  end

  resources :notifications, only: :index
  root to: "feeds#show"
end
