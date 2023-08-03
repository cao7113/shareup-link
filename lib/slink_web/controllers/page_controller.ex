defmodule SlinkWeb.PageController do
  use SlinkWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
