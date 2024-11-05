# Wallet Transaction System

A flexible and robust internal wallet system that enables financial transactions between different entities (Users, Teams, Stocks) with proper ACID compliance and validation.

## Table of Contents
- [Features](#features)
- [Setup](#setup)
- [API Documentation](#api-documentation)
- [LatestStockPrice Library](#lateststockprice-library)

## Features

- Generic wallet implementation for multiple entity types (Users, Teams, Stocks)
- ACID-compliant transactional system
- Balance tracking and calculation
- Custom authentication system
- Stock price integration via RapidAPI
- Comprehensive transaction validation
- Audit trail for all financial operations

## Setup

### Prerequisites
- Ruby 3.2+
- Rails 7.0+
- PostgreSQL 13+
- Redis (for background jobs)

### Installation

1. Clone the repository
```bash
git clone https://github.com/your-username/wallet-system.git
cd wallet-system
```

2. Install dependencies
```bash
bundle install
```

3. Setup database
```bash
rails db:create db:migrate
```

4. Configure environment variables
```bash
cp .env.example .env
# Edit .env with your credentials
```

5. Start the server
```bash
rails server
```

## API Documentation

### Authentication

```
POST /api/v1/sessions
```

Request body:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

Response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "expires_at": "2024-12-01T00:00:00Z"
}
```

### Wallet Operations

#### Create Transaction

```
POST /api/v1/transactions
```

Request body:
```json
{
  "source_wallet_id": 1,
  "target_wallet_id": 2,
  "amount": 100.00,
  "transaction_type": "transfer"
}
```

Response:
```json
{
  "id": 1,
  "status": "completed",
  "amount": "100.00",
  "source_wallet_id": 1,
  "target_wallet_id": 2,
  "created_at": "2024-11-05T12:00:00Z"
}
```

## LatestStockPrice Library

### Usage

```ruby
require 'latest_stock_price'

# Initialize client
client = LatestStockPrice::Client.new(api_key: 'your-rapid-api-key')

# Get single stock price
price = client.price('AAPL')

# Get multiple stock prices
prices = client.prices(['AAPL', 'GOOGL'])

# Get all stock prices
all_prices = client.price_all
```

### Implementation

```ruby
# lib/latest_stock_price/client.rb
module LatestStockPrice
  class Client
    BASE_URL = 'https://latest-stock-price.p.rapidapi.com'
    
    def initialize(api_key:)
      @api_key = api_key
    end
    
    def price(symbol)
      make_request("/price", { symbol: symbol })
    end
    
    def prices(symbols)
      make_request("/price", { symbols: symbols.join(',') })
    end
    
    def price_all
      make_request("/any")
    end
    
    private
    
    def make_request(endpoint, params = {})
      # Implementation details
    end
  end
end
```
