defmodule Ether.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ether.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{})
      |> Ether.Transactions.create_transaction()

    transaction
  end
end
