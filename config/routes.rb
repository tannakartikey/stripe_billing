Rails.application.routes.draw do

  root to: 'users#new'
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  get 'logout',  to: 'sessions#destroy'

  resources :users
  resources :sessions

end
