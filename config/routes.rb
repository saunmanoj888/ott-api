Rails.application.routes.draw do
  namespace :api, format: :json do
    namespace :v1 do
      resources :sessions, only: [:create]
      resources :movies
    end
  end
end
