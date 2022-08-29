defmodule EtherWeb.PageController do
  use EtherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
