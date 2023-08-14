defmodule Slink.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :word, :string
      add :note, :string

      timestamps()
    end
  end
end
