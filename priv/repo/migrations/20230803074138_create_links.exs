defmodule Slink.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :title, :string, size: 255
      add :url, :string, size: 400

      timestamps()
    end

    create unique_index(:links, [:url])
  end
end
