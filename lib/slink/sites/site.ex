defmodule Slink.Sites.Site do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "sites" do
    field :host, :string
    field :domain, :string

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:host, :domain])
    |> validate_required([:host])
    |> unique_constraint(:host)
  end
end
