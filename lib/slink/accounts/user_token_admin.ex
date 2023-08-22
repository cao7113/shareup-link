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
end
