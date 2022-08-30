defmodule Ether.Transactions.Transaction do
  @moduledoc """
  Transaction struct to persist values either in session or cache

  """
  @enforce_keys [:transaction_hash]

  defstruct transaction_hash: nil,
            search_at: nil,
            confirmed?: false,
            confirmed_blocks: 0,
            block_number: nil,
            confirmed_at: nil,
            from: nil,
            to: nil,
            value: nil,
            transaction_fee: nil

  @type t() :: %__MODULE__{
          transaction_hash: String.t(),
          search_at: String.t(),
          confirmed?: boolean(),
          confirmed_blocks: integer(),
          block_number: integer(),
          confirmed_at: String.t(),
          from: String.t(),
          to: String.t(),
          value: String.t(),
          transaction_fee: String.t()
        }

  # %{
  #    "blockHash" => "0xbaee22af41ce5cb4d28a6a377da26f4fc4f9d893fdfaa6878fb732f42367a947",
  #    "blockNumber" => "0x4b9b05",
  #    "from" => "0x0fe426d8f95510f4f0bac19be5e1252c4127ee00",
  #    "gas" => "0x5208",
  #    "gasPrice" => "0x4a817c800",
  #    "hash" => "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0",
  #    "input" => "0x",
  #    "nonce" => "0x2",
  #    "r" => "0xb0a50a9b5e11e36e564d985f3590173a40f231a04c6bfd6132d87244b5b45bcb",
  #    "s" => "0xa936a6f53d7e001a5f5ba6ca182e7e204a7ed0b8c5a7b874041a179d6e1e994",
  #    "to" => "0x4848535892c8008b912d99aaf88772745a11c809",
  #    "transactionIndex" => "0xa0",
  #    "type" => "0x0",
  #    "v" => "0x25",
  #    "value" => "0x526e615a87b5000"
  #  }
  def new(transaction_map) when is_map(transaction_map) do
    transaction = %__MODULE__{
      transaction_hash: transaction_map["hash"],
      block_number: transaction_map["blockNumber"] |> Utils.hex_to_int(),
      from: transaction_map["from"],
      to: transaction_map["to"],
      value: transaction_map["value"] |> Utils.hex_to_int()
    }

    {:ok, transaction}
  end

  def new(_transaction_map), do: {:error, "Could not create Transaction"}
end
