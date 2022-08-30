defmodule EtherWeb.TransactionLive.Transaction do
  @moduledoc """
  Implements entire business logic and interactions for tracking ETH payments
  """
  use EtherWeb, :live_view

  alias Ether.Transactions
  alias Ether.Middleware.BlockNumber
  alias EtherWeb.TransactionLive.AlertComponent

  @update_block_frequency 15_000
  @latency 2_000
  @blocks_to_confirm 2

  @impl true
  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, map}
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :update_block_number, @update_block_frequency)
    end

    socket =
      socket
      |> assign(:page_title, "Transactions")
      |> assign(:transactions, [])
      |> assign(:transaction, nil)
      |> assign(:transaction_hash, nil)
      |> assign(:block_number, BlockNumber.get_block_number())
      |> assign(:toggle_confirmation, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("process_transaction", %{"transaction" => transaction_params}, socket) do
    socket =
      socket
      |> assign(:toggle_confirmation, true)
      |> assign(:transaction_hash, transaction_params["transaction_hash"])

    # Return the values immediately so that interactions can start, keep processing
    # the transaction and update partially
    Process.send_after(self(), {:process_transaction, transaction_params}, 200)

    {:noreply, socket}
  end

  # Handles closing of the modal through frontend
  def handle_event("modal-closed", _, socket) do
    {:noreply, assign(socket, :toggle_confirmation, false)}
  end

  @impl true
  # Update the Current Block Number on the front end.
  # Query the GenServer and push the value to the frontend
  # Also, trigger updating the transaction status
  def handle_info(:update_block_number, socket) do
    Process.send_after(self(), :update_block_number, @update_block_frequency)

    block_number = BlockNumber.get_block_number()

    Process.send_after(self(), :update_transactions, 100)
    {:noreply, assign(socket, block_number: block_number)}
  end

  # Update the transaction status based on the current block number
  def handle_info(:update_transactions, socket) do
    current_transactions = socket.assigns.transactions
    block_number = socket.assigns.block_number

    updated_transactions =
      Transactions.update_transactions(current_transactions, block_number, @blocks_to_confirm)

    {:noreply, assign(socket, transactions: updated_transactions)}
  end

  def handle_info({:process_transaction, transaction_params}, socket) do
    socket =
      case process_transaction(transaction_params, socket) do
        {:ok, transactions} ->
          socket
          |> put_flash(:info, "Transaction Added")
          |> assign(:transactions, transactions)

        {:error, message} ->
          socket
          |> put_flash(:error, message)
      end

    {:noreply, socket}
  end

  # Check for valid hash
  # check if the transaction exists on the chain
  # Add transaction to the transactions
  defp process_transaction(%{"transaction_hash" => transaction_hash}, socket) do
    transactions = socket.assigns.transactions

    with {:ok, _} <- valid_hash(transaction_hash),
         {:ok, transaction_map} <- get_transaction(transaction_hash),
         {:ok, transactions} <- add_transaction(transactions, transaction_map) do
      {:ok, transactions}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  defp valid_hash(transaction_hash) do
    case Transactions.valid_hash(transaction_hash) do
      {:ok, hash} ->
        send_update_after(
          AlertComponent,
          [id: :transaction_confirmation, transaction_valid: true],
          @latency
        )

        {:ok, hash}

      {:error, message} ->
        send_update_after(
          AlertComponent,
          [id: :transaction_confirmation, transaction_valid: false],
          @latency
        )

        {:error, message}
    end
  end

  defp get_transaction(transaction_hash) do
    case Transactions.get_transaction(transaction_hash) do
      {:ok, transaction_map} ->
        send_update_after(
          AlertComponent,
          [id: :transaction_confirmation, transaction_exists: true],
          @latency
        )

        {:ok, transaction_map}

      {:error, message} ->
        send_update_after(
          AlertComponent,
          [id: :transaction_confirmation, transaction_exists: false],
          @latency
        )

        {:error, message}
    end
  end

  defp add_transaction(transactions, transaction_map) do
    case Transactions.add_transaction(transactions, transaction_map) do
      {:ok, transactions} ->
        send_update_after(
          AlertComponent,
          [id: :transaction_confirmation, transaction_added: true],
          @latency
        )

        {:ok, transactions}

      {:error, message} ->
        send_update_after(
          AlertComponent,
          [id: :transaction_confirmation, transaction_added: false],
          @latency
        )

        {:error, message}
    end
  end
end
