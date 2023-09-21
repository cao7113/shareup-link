defmodule Slink.Links.Link do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :url],
    sortable: [:id, :updated_at],
    max_limit: 200,
    default_limit: 10,
    pagination_types: [:page],
    default_order: %{
      order_by: [:id],
      order_directions: [:desc]
    }
  }

  schema "links" do
    field(:title, :string)
    field(:url, :string)

    timestamps()
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:title, :url])
    |> validate_required([:title, :url])
    |> unique_constraint(:url)
  end
end
