Rails.application.routes.draw do

  root 'auth#login'

  resources :feeds, except: [:new] do
    get 'page/:page', action: :show, on: :member
    collection do
      match 'discover', via: [:get, :post]
    end

    resources :feed_items, only: [:show], as: :items
  end
  resources :groups, except: [:new]

  match 'setup' => 'setup#setup', via: [:get, :post], as: :setup

  match 'login' => 'auth#login', via: [:get, :post], as: :login
  delete 'login' => 'auth#logout', as: :logout


  # Fever API Endpoint
  get   '/fever' => 'fever#fever'
  post  '/fever' => 'fever#fever'
end
