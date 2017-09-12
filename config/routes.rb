Rails.application.routes.draw do

  root to: 'users#new'
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  get 'logout',  to: 'sessions#destroy'
  get 'my_account', to: 'my_account#index'
  post 'stripe_events', to: 'stripe#events', as: 'stripe_events'

  resources :users
  resources :sessions

end
