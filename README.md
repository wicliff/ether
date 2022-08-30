# Ether
Ether is an ETH payment tracking system. The application takes in a transaction hash and tracks the transaction until a sufficient number of blocks are confirmed.

A full description of the functionality is towards the end of the README.

### Installation
The app is a standard phoenix project without any dependencies. 

1. Clone the project from the Repo
```
git clone git@github.com:wicliff/ether.git
cd ether

```

2. Install `asdf` package manager if not installed already

Refer:
https://github.com/asdf-vm/asdf

3. Install asdf plugins for erlang and elixir

Refer:
https://github.com/asdf-vm/asdf-erlang

https://github.com/asdf-vm/asdf-elixir


4. Install Erlang & Elixir (.tool-versions file already has the necessary versions needed)

```
asdf install
```

### Running
Run the project using `mix phx.server`

```
iex -S mix phx.server
```

In the browser http://localhost:4000/


### Tests
Core tests implemented

```
mix test
```


## Description
Ether tracks the payment transactions to verify confirmation of the transaction. 

The application is entirely built in Phoenix LiveView and uses GenServer to track Payment status. Additionally, TailwindCSS is used for the frontend UI.

Transactions are stored in memory - in the connected socket, so there is no need for ecto or databases. This means transactions will disappear if the browser is refreshed, and an enhanced way would be to implement sessions using ETS. But for the current implementation storing in the socket would suffice.


### Adding Transaction
A User enters the transaction hash, which needs to be tracked. The process followed is as below

1. Application verifies that the transaction hash is valid
2. A call to the ETH mainet is done to verify the transaction exists on the network, and get the details of the transaction
3. The transaction is added to the list of transactions that are tracked.

### Tracking Block Number
The application tracks the current block number. 
A GenServer calls the ETH network every 15 seconds to get the value and store it in memory.

### Updating Payment Status
The transactions which the User adds are stored in the memory (socket). The screen displays these transactions.

Current Block Number is also shown on the screen. LiveView gets this value from the GenServer at a set frequency and updates the front end.

While updating the front end, the status of the transactions is also verified and updated accordingly.


### Confirming Payment
The transaction is marked confirmed when the difference between the current block number and the transaction block number is more than 2.

The updates to the screen and API calls are kept with varied latency to simulate real scenarios.

###  Accessing ETH Network
For tracking the payment transactions and the current block number, the application uses the mainnet through the infura API. 
The API is accessed using the JSON-RPC client implemented in the hex package `ethereumex`

