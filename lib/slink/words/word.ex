defmodule Slink.Words.Word do
  use Ecto.Schema
  import Ecto.Changeset

  schema "words" do
    field :note, :string
    field :word, :string

    timestamps()
  end

  @doc false
  def changeset(word, attrs) do
    word
    |> cast(attrs, [:word, :note])
    |> validate_required([:word, :note])
  end
end
