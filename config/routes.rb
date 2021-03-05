Rails.application.routes.draw do
  namespace :api, format: :json do
    namespace :v1 do
      resources :sessions, only: [:create]
      resources :movies, shallow: true do
        resources :ratings, only: [:create, :update, :index]
        resources :reviews, only: [:create, :update, :index]
      end
    end
  end
end
