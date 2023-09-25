defmodule Slink.Links.Link do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:title, :url, :tags],
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
    field(:tags, {:array, :string}, default: [])
    field(:site_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, [:title, :url, :site_id, :tags])
    |> validate_required([:title, :url])
    |> unique_constraint(:url)
    |> prepare_changes(fn changeset ->
      case changeset.action do
        :insert ->
          new_tags = Slink.Links.auto_tags(changeset.changes)

          changeset
          |> put_change(:tags, new_tags)

        _ ->
          changeset
      end
    end)
  end
end
