defmodule Slink.Accounts.UserTokenAdmin do
  def index(_) do
    [
      id: nil,
      token: %{
        name: "Token",
        value: fn it ->
          <<prefix::16-binary, _::32-binary, suffix::16-binary>> = it.token |> Base.encode16()
          <<prefix::binary, "...(32)...", suffix::binary>>
        end
      },
      context: nil,
      sent_to: nil,
      user_id: nil,
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
          |> Slink.Accounts.tokens_query_from_ids()
          |> Slink.Repo.delete_all()

          :ok
        end
      }
    ]
  end
end
