# FoodChainTruffleProject

This repository contains the frontend, backend, and Ethereum smart contracts for the Food Chain application, which tracks and validates food items from seed selection to end consumer.

## Table of Contents

* Directory Structure
* Setup
* Prerequisites
  -  Backend Setup
  -  Frontend Setup
  -  Smart Contract Setup
  -  Running the Application
* Features
* Contribution

## Directory Structure
```lua
/food-chain-app
|-- /backend
|   |-- /routes
|   |-- /models
|   |-- /middlewares
|   |-- /controllers
|   |-- package.json
|   |-- server.js
|
|-- /frontend
|   |-- /src
|   |-- /public
|   |-- package.json
|   |-- .env
|
|-- /smart-contracts
|   |-- /migrations
|   |-- /contracts
|       |-- FoodChain.sol
|   |-- truffle-config.js
|
|-- README.md
```

## Setup

### Prerequisites

* Node.js and npm
* Ethereum Wallet
* Truffle

### Backend Setup

Navigate to the backend directory:

```bash
cd backend
```

Install dependencies:

```bash
npm install
```

Set up environment variables. Rename .env.example to .env and fill in the required values.

### Frontend Setup

Navigate to the frontend directory:

```bash
cd frontend
```

Install dependencies:

```bash
npm install
```

Set up environment variables. Rename .env.example to .env and fill in the required values.

### Smart Contract Setup

Navigate to the smart-contracts directory:

```bash
cd smart-contracts
```

Compile the contracts:

```bash
truffle compile
```

Deploy the contracts:

```bash
truffle migrate --network <your_network_name>
```

### Running the Application

In the root directory:

Start the backend:

```bash
npm run start:backend
```

In a separate terminal, start the frontend:

```bash
npm run start:frontend
```

## Features
* Track food items from seed selection to the end consumer.
* Multiple stages of validation, including lab tests.
* QR code generation for each stakeholder to fetch information.
* Secure encryption and decryption of data.
* Ethereum smart contracts for tracking and validation.

## Contribution
We welcome contributions to the Food Chain application. Please follow the standard git workflow:

* Fork the repo.
* Create a new feature branch.
* Make your changes and commit them.
* Push to your fork.
* Create a pull request to this repo.
