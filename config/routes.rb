Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  post '/users/:id/request', to: 'users#request_friendship', as: 'request_friendship'
  get 'friendship-requests', to: 'users#friendship_requests', as: 'friendship_requests'
  post 'requests/:id/approve', to: 'users#approve_request', as: 'approve_request'
  post 'requests/:id/decline', to: 'users#decline_request', as: 'decline_request'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
