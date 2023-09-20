Rails.application.routes.draw do

  # ユーザー新規登録、ログイン
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  devise_scope :user do
    post 'guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  # 管理者ログイン
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  get 'search', to: 'searches#search' # 検索

  # ユーザー用
  scope module: :public do
    root to: 'homes#top'
    get 'about', to: 'homes#about'
    resources :users, only: %i[show update] do
      member do
        get 'edit_information', as: 'edit'
        get 'unsubscribe'
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
    resources :room_groups #グループチャット
  end

  # 管理者用
  namespace :admin do
    root to: 'posts#top'
    resources :users, except: %i[new create edit]
    resources :posts, only: %i[show edit update destroy]
    resources :commets, only: %i[index destroy]
  end
end
