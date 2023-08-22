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

  def plain(conn, _params) do
    conn
    |> put_root_layout(html: :root_bare)
    |> put_layout(html: :app_bare)
    # |> put_layout(false)
    |> render(:plain)
  end
end
