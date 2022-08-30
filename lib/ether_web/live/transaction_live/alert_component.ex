defmodule EtherWeb.TransactionLive.AlertComponent do
  use EtherWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
    <%= if is_nil(@transaction_hash) do %>
      -
    <% else %>
      <%= @transaction_hash %>
    <% end %>

      <div class="mt-4">
        <table class="table-auto">
          <tbody>
            <tr>
              <td><%= raw Utils.show_status(@transaction_valid) %></td>
              <td>Valid Transaction Hash</td>
            </tr>
            <tr>
              <td><%= raw Utils.show_status(@transaction_exists) %></td>
              <td>Transaction exists on the Mainnet</td>
            </tr>
            <tr>
              <td><%= raw Utils.show_status(@transaction_added) %></td>
              <td>Transaction added. Awaiting payment confirmation.</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end
end
