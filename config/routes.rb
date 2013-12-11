Beanbook::Application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show] do
    resources :posts, except: [:index, :new]
  end

  root to: "users#show"
end
