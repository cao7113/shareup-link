defmodule Slink.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :content, :string
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :content])
    |> validate_required([:content])
  end
end
