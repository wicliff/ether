defmodule EtherWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.
  """
  def modal(assigns) do
    ~H"""
    <div id="modal" class="fixed top-0 left-0 right-0 z-50 w-full h-screen overflow-x-hidden overflow-y-auto fade-in md:inset-0 h-modal md:h-full" phx-remove={hide_modal()}>
     <div class="relative w-full h-full max-w-2xl p-4 md:h-auto">
      <div
        id="modal-content"
        class="relative p-4 text-gray-700 rounded-lg shadow bg-blue-50 fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
           <!-- Modal header -->
            <div class="flex items-start justify-between p-4 border-b border-gray-400 rounded-t">
                <h3 class="text-xl font-semibold">
                Processing Transaction...
                </h3>
                <button id="close"
                type="button"
                phx-click={hide_modal()}
                class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center">
                    <svg aria-hidden="true" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path></svg>
                    <span class="sr-only">Close modal</span>
                </button>
            </div>
            <div class="mt-4 mb-4">
        <%= render_slot(@inner_block) %>
            </div>

         <!-- Modal footer -->
            <div class="flex justify-end p-6 space-x-2 border-t border-gray-300 rounded-b">
                <button type="button"
                phx-click={JS.dispatch("click", to: "#close")}
                class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center ">
                  Close
                </button>
            </div>
          </div>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.push("modal-closed")
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
