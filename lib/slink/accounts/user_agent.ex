defmodule Slink.Accounts.UserAgent do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "user_agents" do
    field(:label, :string)
    field(:agent, :string)
    field(:last_user_id, :integer)
    field(:last_ip, :string)
    field(:note, :string)

    timestamps()
  end

  @doc false
  def changeset(user_agent, attrs) do
    user_agent
    |> cast(attrs, [:label, :agent, :last_user_id, :last_ip, :note])
    |> validate_required([:agent, :last_ip])
  end
end
