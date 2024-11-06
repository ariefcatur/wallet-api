Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'sessions#create'

      resources :wallets, only: [:index, :show] do
        member do
          post :deposit
          post :withdraw
          post :transfer
        end
      end

      resources :transactions, only: [:index, :show]
      resources :stocks, only: [:index, :show]
    end
  end
end