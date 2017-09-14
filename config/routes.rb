Rails.application.routes.draw do

  root to: 'users#new'
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  get 'logout',  to: 'sessions#destroy'
  post 'getin', to: 'sessions#getin'
  get 'my_account', to: 'my_account#index'
  get 'only_pro', to: 'only_pro#index'
  post 'stripe_events', to: 'stripe#events', as: 'stripe_events'

  resource :my_account, only: [:show, :destroy], controller: 'my_account'
  resources :users
  resources :sessions
  resource :plan, only: [:show], controller: 'plans'
  resource :card
end
