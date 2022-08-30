defmodule Ether.Middleware.BlockNumber do
  @moduledoc """
  Get the latest block number at a frequency and store for the later use
  """
  use GenServer
  require Logger
  @frequency 15_000

  def start_link(initial_state \\ 0) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def get_block_number() do
    GenServer.call(__MODULE__, {:get_block_number})
  end

  @impl true
  def init(_args) do
    Logger.info("Initializing the Block Number to 0")

    block_number = 0
    schedule_update(100)
    {:ok, block_number}
  end

  @impl true
  def handle_call({:get_block_number}, _from, block_number) do
    {:reply, block_number, block_number}
  end

  @impl true
  def handle_info(:update_block_number, _block_number) do
    Logger.info("Updating the Block Number from Mainnet")

    schedule_update(@frequency)

    # Get the total block count
    block_number =
      case Ethereumex.HttpClient.eth_block_number() do
        {:ok, block_number_hex} ->
          Utils.hex_to_int(block_number_hex)

        {:error, _} ->
          0
      end

    Logger.info("Updated Block Number - #{block_number}")
    {:noreply, block_number}
  end

  defp schedule_update(frequency) do
    Process.send_after(self(), :update_block_number, frequency)
  end
end
