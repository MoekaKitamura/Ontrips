Rails.application.routes.draw do
  root 'tops#index'
  get 'tops/index'
  resources :talks do
    resources :messages
  end
  resources :members, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :profiles
  resources :trips do
    resources :comments
    member do
      post :change_goal
    end
    collection do
      get :favorite
      get :member
    end
  end
  resources :blogs
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
    post 'users/guest_admin_sign_in', to: 'users/sessions#new_guest_admin'
    get 'confirm_email', to: 'users/registrations#confirm_email'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
