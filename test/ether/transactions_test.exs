defmodule Ether.TransactionsTest do
  use ExUnit.Case

  alias Ether.Transactions

  describe "transactions" do
    alias Ether.Transactions.Transaction

    import Ether.TransactionsFixtures

    @invalid_attrs %{}
    @valid_hash "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"

    test "get_transaction/1 calls ETH network to return transaction values" do
      assert {:ok, %{} = transaction_map} = Transactions.get_transaction(@valid_hash)
    end
  end
end
