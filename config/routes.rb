Rails.application.routes.draw do

  # ユーザー新規登録、ログイン
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # ゲストログイン
  devise_scope :user do
    post 'guest_sign_in', to: 'users/sessions#guest_sign_in'
    get 'users', to: 'public/registrations#new'
  end

  # 管理者ログイン
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # ユーザー用
  scope module: :public do
    root to: 'homes#top'
    get 'search', to: 'searches#search'
    resources :users, only: %i[show update] do
      member do
        get 'edit_information', as: 'edit'
        patch 'withdrawal'
        get :likes  # いいね一覧
        get 'timeline'
      end
      resource :relations, only: %i[create destroy]
      get 'followings', to: 'relations#followings', as: 'followings'
      get 'followers', to: 'relations#followers', as: 'followers'
    end
    resources :posts do
      resource :likes, only: %i[create destroy]
      resources :comments, only: %i[create destroy] do
        resource :comment_likes, only: %i[create destroy]
      end
    end
    resources :tags, only: %i[show]
    resources :notifications, only: %i[index]
    resources :rooms, only: %i[index show create]
    resources :messages, only: %i[create]
    resources :room_groups do #グループチャット
      resources :message_groups, only: %i[create]
      resources :user_groups, only: %i[create index destroy]
    end
    resources :rates, only: %i[new create]
    resources :violates, only: %i[create]
  end

  # 管理者用
  namespace :admin do
    root to: 'users#index'
    resources :users, only: %i[index show edit update]
    resources :posts, only: %i[index show destroy]
    resources :tags, only: %i[index show]
    resources :comments, only: %i[index destroy]
    resources :rates, only: %i[index]
    resources :violates, only: %i[index]
  end
end
