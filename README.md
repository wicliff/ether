# Ether
Ether is a ETH payment tracking system. The application takes in a transaction hash and tracks the transaction until the sufficient number of blocks are confirmed.

# Installation
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

# Running
Run the project using `mix phx.server`

```
iex -S mix phx.server
```

# Tests
Core tests implemented

```
mix test
```