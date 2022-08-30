defmodule Ether.Transactions do
  @moduledoc """
  The Transactions context.
  """

  alias Ether.Transactions.Transaction
  require Logger

  @hash_format ~r/^0x([A-Fa-f0-9]{64})$/

  def add_transaction(transactions, transaction_map) do
    if transaction_exists?(transactions, transaction_map) do
      {:ok, transactions}
    else
      create_and_add_transaction(transactions, transaction_map)
    end
  end

  defp transaction_exists?(transactions, %{"hash" => transaction_hash}) do
    transactions
    |> Enum.any?(fn t -> t.transaction_hash == transaction_hash end)
  end

  defp create_and_add_transaction(transactions, transaction_map) do
    case create_transaction(transaction_map) do
      {:ok, transaction} ->
        {:ok, [transaction | transactions]}

      {:error, _} ->
        {:error, transactions}
    end
  end

  def create_transaction(transaction_map) do
    Transaction.new(transaction_map)
  end

  def valid_hash(transaction_hash) when is_binary(transaction_hash) do
    case Regex.match?(@hash_format, transaction_hash) do
      true -> {:ok, transaction_hash}
      false -> {:error, "Invalid Transaction Hash Format"}
    end
  end

  def valid_hash(_transaction_hash),
    do: {:error, "Invalid Transaction Hash Format"}

  def get_transaction(transaction_hash) do
    Logger.debug("Calling ETH API")

    case Ethereumex.HttpClient.eth_get_transaction_by_hash(transaction_hash) do
      {:error, message} ->
        Logger.debug("Get Transaction By Hash - Call Failed")
        Logger.debug(message)
        {:error, "Transaction does not exist on the chain"}

      {:ok, transaction_map} ->
        {:ok, transaction_map}
    end
  end

  def update_transactions(transactions, block_number, blocks_to_confirm) do
    Enum.map(transactions, fn t ->
      value = block_number - t.block_number >= blocks_to_confirm
      Map.put(t, :confirmed?, value)
    end)
  end
end
