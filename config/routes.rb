Rails.application.routes.draw do

  root 'auth#login'

  resources :feeds do
    get 'page/:page', action: :show, on: :member
    collection do
      match 'discover', via: :post
      match 'update_feed_group', via: :post
    end

    resources :feed_items, only: [:show], as: :items do
      member do
        get 'mark/read' => 'feed_items#mark_read'
        get 'mark/unread' => 'feed_items#mark_unread'
      end
    end
  end
  resources :groups, except: [:new]

  match 'setup' => 'setup#setup', via: [:get, :post], as: :setup

  match 'login' => 'auth#login', via: [:get, :post], as: :login
  delete 'login' => 'auth#logout', as: :logout


  # Fever API Endpoint
  get   '/fever' => 'fever#fever'
  post  '/fever' => 'fever#fever'

  get '/image_proxy/:image_hash(/api_key/:api_key)' => 'proxy#image_proxy', as: :image_proxy
end
