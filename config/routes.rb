Rails.application.routes.draw do

  root to: 'users#new'
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  get 'logout',  to: 'sessions#destroy'
  get 'my_account', to: 'my_account#index'
  get 'only_pro', to: 'my_account#pro'
  post 'stripe_events', to: 'stripe#events', as: 'stripe_events'

  resources :users
  resources :sessions
  resource :card

end
