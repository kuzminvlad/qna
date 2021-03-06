require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  resources :authorizations, only: %i[new create]

  concern :votable do
    member  do
      patch 'vote_up'
      patch 'vote_down'
      delete 'delete_vote'
    end
  end

  concern :commentable do
    member do
      post 'create_comment'
      delete 'delete_comment'
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: { commentable: 'questions' }
    resources :answers, concerns: :votable, shallow: true do
      resources :comments, only: :create, defaults: { commentable: 'answers' }
      member do
        patch 'set_best'
      end
    end
    resources :subscriptions, only: :create do
      delete :destroy, on: :collection
    end
  end

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
      end
      resources :questions, only: %i[show index create] do
        resources :answers, only: %i[show index create]
      end
    end
  end

  resources :search, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
