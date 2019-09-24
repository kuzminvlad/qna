Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  # resources :answers, only: [:new, :show, :create, :destroy]
  resources :questions do
    resources :answers, shallow: true
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"
end
