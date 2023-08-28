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
  
  #ユーザー用
  scope module: :public do
    root to: 'homes#top'
    get 'homes/about', to: 'homes#about', as: 'about'
    get 'users/show'
    get 'users/edit_information', to: 'users#edit', as: 'users_edit'
    post 'users/update'
    get 'users/unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'
    patch 'users/withdrawal', to: 'users#withdrawal', as: 'withdrawal'
    resources :posts
  end
  
  #管理者用
end
