defmodule Slink.Tags.Tag do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tags" do
    field(:name, :string)
    field(:auto_match_touch_at, :utc_datetime)
    field(:pin_top_touch_at, :utc_datetime)

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :auto_match_touch_at, :pin_top_touch_at])
    |> update_change(:name, fn
      nil ->
        nil

      name when is_binary(name) ->
        String.trim(name)
    end)
    |> validate_required([:name])
    |> maybe_validate_unique_name()
  end

  defp maybe_validate_unique_name(changeset, opts \\ []) do
    if Keyword.get(opts, :validate_name, true) do
      changeset
      |> unsafe_validate_unique(:name, Slink.Repo)
      |> unique_constraint(:name)
    else
      changeset
    end
  end
end
