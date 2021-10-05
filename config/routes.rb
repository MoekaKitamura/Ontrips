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
  end
  resources :blogs
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
