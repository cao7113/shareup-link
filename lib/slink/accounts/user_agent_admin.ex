defmodule Slink.Accounts.UserAgentAdmin do
  import Ecto.Query
  alias Slink.Accounts

  def index(_) do
    [
      id: nil,
      agent: %{
        name: "UserAgent",
        value: fn it ->
          it.agent |> String.slice(0, 60)
        end
      },
      last_user_id: nil,
      last_ip: nil,
      inserted_at: nil
    ]
  end

  def list_actions(_conn) do
    [
      delete_all: %{
        name: "Delete All",
        action: fn _conn, users ->
          users
          |> Enum.map(& &1.id)
          |> then(fn ids ->
            from(a in Accounts.UserAgent, where: a.id in ^ids)
          end)
          |> Slink.Repo.delete_all()

          :ok
        end
      }
    ]
  end
end
