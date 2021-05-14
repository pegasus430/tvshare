require 'sidekiq/web'

Rails.application.routes.draw do
  resources :categories, only: [:index, :show], defaults: { format: :json }
  resource :guide do
    member do
      get :live
      get :upcoming
    end
  end

  resource :report, only: [:create]
  resources :notifications, only: [:index, :update] do
    collection do
      resources :unread, only: [:index, :update], module: :notifications
    end
  end


  get 'search', to: 'search#index', as: :search_index
  resources :relationships, only: [:index, :create, :destroy]
  resources :news, only: [:index]
  namespace :admin do
    # TODO: Password-protect this route
    mount Sidekiq::Web => '/background-jobs'

    namespace :matching do
      resource 'networks' do
        get '/', to: 'networks#index'
        get '/shows', to: 'networks#shows'
        put '/match', to: 'networks#match'
      end
    end

    resources :categories
    get 'matching', to: 'matching#index'
    get 'categories', to: 'categor#index'
    get 'matching/shows'
    get 'matching/possible_matches'
    put 'matching/match'
    post 'matching/import'
    get 'matching/:tms_id', to: 'matching#show'
  end

  namespace :shows do
    resource :originals do
      get '/', to: 'originals#index'
      get '/:network', to: 'originals#show', as: :network
    end

    resource :genres, defaults: { format: :json }  do
      get '/', to: 'genres#index'
      get '/live', to: redirect(path: '/guide/live'), as: :live
      get '/upcoming', to: redirect(path: '/guide/upcoming'), as: :upcoming
      get '/:genre', to: 'genres#show', as: :genre
    end
  end

  resources :sub_comments
  resources :recommendations
  # resources :ratings
  # resources :quality_ratings
  resources :preferred_images
  resources :keywords
  resources :crews
  resources :casts
  resources :awards
  resources :shows do
    member do
      get 'news', to: 'shows/news#index'
      get 'episodes', to: 'shows/episodes#index'
    end
    resources :ratings, only: [:create], module: :shows
  end

  resources :likes
  resources :comments

  post '/auth/login', to: 'authentication#login'
  post '/auth/login_social', to: 'authentication#login_social'
  get '/auth/verify', to: 'authentication#verify'
  resources :shares, only: [:create]
  get '/users/location', to: 'users#location'

  resources :users, only: [:show, :update, :create], param: :username, username: /[^\/]+/ do
    get :reactions
    get :favorites
    get :followers
    get :following
  end

  resource :profile, only: [:show] do
    get :reactions
    get :favorites
    get :followers
    get :following
  end

  resource :password_reset, only: [] do
    get :exists
    post :generate
    post :save
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
