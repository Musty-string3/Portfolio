Rails.application.routes.draw do

  #ユーザー新規登録、ログイン
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  #管理者ログイン
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  get 'search', to: 'searches#search'

  #ユーザー用
  scope module: :public do
    root to: 'homes#top'
    get 'about', to: 'homes#about'
    get 'users/show'
    get 'users/edit_information', to: 'users#edit', as: 'users_edit'
    post 'users/update'
    get 'users/unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'
    patch 'users/withdrawal', to: 'users#withdrawal', as: 'withdrawal'
    resources :posts do
      collection do
        get 'index_current'
      end
    end
  end

  #管理者用
  namespace :admin do
    root to: 'posts#top'
    resources :users, except: %i[new create edit]
    resources :posts, only: %i[show edit update destroy] 
  end
end
