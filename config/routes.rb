Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      # get "/users", to: "users#index"
      # post "/users/", to: "users#create"

      resources :users
      resources :tokens , only: %i[create]
      resources :products, only: %i[show index create update destroy ]

    end
  end
end
