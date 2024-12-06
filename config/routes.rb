Rails.application.routes.draw do
  get "users/mypage"

  # deviseのルートを設定
  devise_for :users

  # home_indexをルートパスに設定
  root 'restaurants#home_index' 
  get 'home', to: 'restaurants#home_index', defaults: { format: :html }

  # 検索画面のルート
  get 'restaurants/search', to: 'restaurants#search', defaults: { format: :html }
  get 'restaurants/:id', to: 'restaurants#show', as: 'restaurant' 

  # ブックマーク画面のルート
  get 'bookmarks/bookmarks', to: 'bookmarks#bookmarks', as: 'bookmarks'

  
  resources :bookmarks, only: [:create, :destroy, :index]

  authenticated :user do
    root to: 'restaurants#home_index', as: :authenticated_root
  end
  
  # devise関連のルート
  unauthenticated do
    root to: 'devise/sessions#new', as: :unauthenticated_root
  end

  devise_scope :user do
    get 'users/logout', to: 'devise/sessions#logout', as: :logout
  end

  
  # マイページのルート
  get 'user/mypage', to: 'users#mypage', as: 'user_mypage'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
