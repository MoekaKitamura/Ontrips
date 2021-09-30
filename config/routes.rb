Rails.application.routes.draw do
  resources :favorites, only: [:create, :destroy]
  resources :profiles
  resources :trips
  resources :blogs
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  root 'blogs#index'
end
