Rails.application.routes.draw do
  # API versioning using namespaces
  namespace :api do
    namespace :v1 do
      # Session management routes
      resources :sessions, only: [:create]  # POST /api/v1/sessions - for user login

      # User management routes
      resources :users, only: [:create]     # POST /api/v1/users - for user creation

      # Transaction routes
      resources :transactions, only: [:create, :index] do
        collection do
          # GET /api/v1/transactions - list all transactions for current user
          # POST /api/v1/transactions - create new transaction
        end
      end

      # Wallet routes
      get 'wallet/:owner_type/:owner_id', to: 'wallets#show'  # GET /api/v1/wallet/user/1

      # Stock price routes
      get 'stocks/price/:symbol', to: 'stocks#price'          # GET /api/v1/stocks/price/AAPL
      get 'stocks/prices', to: 'stocks#prices'                # GET /api/v1/stocks/prices?symbols=AAPL,GOOGL
      get 'stocks/price_all', to: 'stocks#price_all'         # GET /api/v1/stocks/price_all
    end
  end
end