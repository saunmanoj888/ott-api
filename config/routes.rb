Rails.application.routes.draw do
  namespace :api, format: :json do
    namespace :v1 do
      resources :sessions, only: [:create]
      resources :movies, shallow: true do
        resources :ratings, only: [:create, :update, :index, :destroy]
        resources :reviews, only: [:create, :update, :index, :destroy]
      end
      resources :users, only: [:create] do
        member do
          delete 'remove_permission'
          post 'assign_permission'
        end
      end
      resources :permissions, only: [:create, :destroy]
    end
  end
end
