defmodule Slink.Tags.Tag do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tags" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
