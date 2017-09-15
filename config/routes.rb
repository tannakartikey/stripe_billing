Rails.application.routes.draw do

  root to: 'users#new'
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  get 'logout',  to: 'sessions#destroy'
  post 'getin', to: 'sessions#getin'
  get 'my_account', to: 'my_account#index'
  get 'only_pro', to: 'only_pro#index'
  post 'stripe_events', to: 'stripe#events', as: 'stripe_events'
  post 'repay', to: 'charges#repay', as: 'repay'

  resources :users
  resources :sessions
  resources :invoice, only: [:index], controller: 'invoices'
  resource :charge, only: [:show, :new, :create], controller: 'charges'
  resource :my_account, only: [:show, :destroy], controller: 'my_account'
  resource :plan, only: [:show], controller: 'plans'
  resource :card
end
