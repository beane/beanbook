Beanbook::Application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:index, :new, :create, :show, :update] do
    resources :posts, except: [:index, :new]
    resources :friends, only: :index
    resources :friendships, only: [:create, :update, :destroy]
    resources :photos
    resources :tags, only: [:index, :create, :destroy]
  end

  resource :feed, only: :show

  root to: "feeds#show"
end
