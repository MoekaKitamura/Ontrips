Rails.application.routes.draw do
  root 'tops#index'
  get 'tops/index'
  resources :talks, only: %i[index create] do
    resources :messages, only: %i[index create]
  end
  resources :members, only: %i[create destroy]
  resources :favorites, only: %i[create destroy]
  resources :profiles, only: %i[index show edit update]
  resources :trips do
    resources :comments, only: %i[create edit update destroy]
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
