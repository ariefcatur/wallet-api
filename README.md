# Wallet Transaction System

A flexible and robust internal wallet system that enables financial transactions between different entities (Users, Teams, Stocks) with proper ACID compliance and validation.

## Table of Contents
- [Setup](#setup)
- [API Documentation](#api-documentation)

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
curl --location 'http://localhost:3000/api/v1/login' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

Response:
```json
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzA5NTgzNzZ9.YQ9wZ1f0g5nw_09pbtBEnMJcFhtBjFCDhWZWkew1Vt8",
    "user": {
        "id": 1,
        "email": "test@example.com"
    }
}
```

### Wallet Operations

#### Create Deposit

```
curl --location 'http://localhost:3000/api/v1/wallets/1/deposit' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzA5NTgzNzZ9.YQ9wZ1f0g5nw_09pbtBEnMJcFhtBjFCDhWZWkew1Vt8' \
--header 'Content-Type: application/json' \
--data '{
    "amount": 100.00
  }'
```

Response:
```json
{
    "message": "Transaction successful",
    "transaction": {
        "id": 1,
        "amount": 100.0,
        "source_wallet_id": null,
        "target_wallet_id": 1,
        "created_at": "2024-11-06T06:01:18.236Z"
    }
}
```

#### Transfer Money

```
curl --location 'http://localhost:3000/api/v1/wallets/1/transfer' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzA5NTgzNzZ9.YQ9wZ1f0g5nw_09pbtBEnMJcFhtBjFCDhWZWkew1Vt8' \
--header 'Content-Type: application/json' \
--data '{
    "target_wallet_id": 2,
    "amount": 25.00
  }'
```

Response:
```json
{
    "message": "Transaction successful",
    "transaction": {
        "id": 2,
        "amount": 25.0,
        "source_wallet_id": 1,
        "target_wallet_id": 2,
        "created_at": "2024-11-06T06:04:48.410Z"
    }
}
```

#### Withdraw Money

```
curl --location 'http://localhost:3000/api/v1/wallets/1/withdraw' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzA5NTgzNzZ9.YQ9wZ1f0g5nw_09pbtBEnMJcFhtBjFCDhWZWkew1Vt8' \
--header 'Content-Type: application/json' \
--data '{
    "amount": 50.00
  }'
```

Response:
```json
{
    "message": "Transaction successful",
    "transaction": {
        "id": 3,
        "amount": 50.0,
        "source_wallet_id": 1,
        "target_wallet_id": null,
        "created_at": "2024-11-06T06:43:56.733Z"
    }
}
```

#### Get Transaction History

```
curl --location 'http://localhost:3000/api/v1/transactions' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzA5NTgzNzZ9.YQ9wZ1f0g5nw_09pbtBEnMJcFhtBjFCDhWZWkew1Vt8' \
--header 'Content-Type: application/json'
```

Response:
```json
[
    {
        "id": 1,
        "source_wallet_id": null,
        "target_wallet_id": 1,
        "amount_cents": 10000,
        "description": null,
        "created_at": "2024-11-06T06:01:18.236Z",
        "updated_at": "2024-11-06T06:01:18.236Z"
    },
    {
        "id": 2,
        "source_wallet_id": 1,
        "target_wallet_id": 2,
        "amount_cents": 2500,
        "description": null,
        "created_at": "2024-11-06T06:04:48.410Z",
        "updated_at": "2024-11-06T06:04:48.410Z"
    }
]
```
