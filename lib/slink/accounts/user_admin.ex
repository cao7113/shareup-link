defmodule Slink.Accounts.UserAdmin do
  def index(_) do
    [
      id: nil,
      email: nil,
      confirmed_at: nil,
      inserted_at: nil,
      updated_at: nil
    ]
  end

  def list_actions(_conn) do
    [
      delete_all: %{
        name: "Delete All",
        action: fn _conn, users ->
          users
          |> Enum.map(& &1.id)
          |> Slink.Accounts.users_query_from_ids()
          |> Slink.Repo.delete_all()

          :ok
        end
      }
    ]
  end

  def resource_actions(_conn) do
    [
      delete: %{
        name: "Delete User",
        action: fn _c, u ->
          Slink.Accounts.User.delete(u)
        end
      }
    ]
  end

  def custom_links(_) do
    [
      %{
        name: "Web Home",
        url: "/",
        location: :bottom,
        order: 1
      },
      %{
        name: "Demo Repo",
        url: "https://github.com/aesmail/kaffy-demo",
        location: :bottom,
        order: 2,
        target: "_blank"
      },
      %{
        name: "Demo Site",
        url: "https://kaffy.fly.dev/admin/dashboard",
        location: :bottom,
        order: 3,
        target: "_blank"
      },
      %{
        name: "Kaffy Repo",
        url: "https://github.com/aesmail/kaffy",
        location: :bottom,
        target: "_blank"
        # order: 4
      },
      %{
        name: ~s(Google: kaffy admin),
        url: "https://www.google.com/?q=kaffy+admin",
        # data: [confirm: "You will be taken to google search page."],
        location: :bottom,
        target: "_blank"
      }
    ]
  end
end
