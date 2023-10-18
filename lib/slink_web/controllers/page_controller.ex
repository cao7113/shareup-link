defmodule SlinkWeb.PageController do
  use SlinkWeb, :controller
  import SlinkWeb.UserAuth

  plug(:require_authenticated_admin when action in [:test])

  def welcome(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def index(conn, _params) do
    render(conn, :index)
  end

  def blank(conn, _params) do
    conn
    |> put_root_layout(html: :bare_root)
    |> put_layout(html: :bare_app)
    |> render(:blank)
  end

  def test(conn, _params) do
    conn
    |> render(:test)
  end

  def tailwind(conn, _params) do
    conn
    # |> put_root_layout(false)
    |> put_root_layout(html: :bare_root)
    |> put_layout(false)
    |> render(:tailwind)
  end
end
