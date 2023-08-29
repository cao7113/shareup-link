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
    |> put_root_layout(html: :bare_root)
    |> put_layout(html: :bare_app)
    |> render(:plain)
  end

  def tailwind(conn, _params) do
    conn
    # |> put_root_layout(false)
    |> put_root_layout(html: :bare_root)
    |> put_layout(false)
    |> render(:tailwind)
  end
end
