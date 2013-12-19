Beanbook::Application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :users, except: :destroy do
    resources :posts, except: [:index, :new, :show]
    resources :friends, only: :index
    resources :friendships, only: [:create, :update, :destroy]
    resources :photos
    resources :tags, only: [:index, :create, :destroy]
    resources :user_likes, only: [:update, :destroy] # this is a little hacky, see user_likes controller and user_likes/_form
  end

  resources :comments, only: [:create, :destroy]
  resources :conversations, except: :destroy
  resources :posts, only: :show
  resources :notifications, only: :index

  root to: "feeds#show"
end
