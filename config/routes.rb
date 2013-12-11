Beanbook::Application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show] do
    resources :posts, except: [:index, :new]
    member do
      # this doesn't work yet - need friend model
      get :feed
    end
  end

  # eventually change to the current user's feed
  # hmmm....
  root to: "users#show"
end
