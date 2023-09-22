defmodule Slink.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :host, :string, null: false, comment: "host with scheme"
      add :domain, :string, null: false, comment: "base domain"

      timestamps()
    end

    create unique_index(:sites, [:host])

    alter table(:links) do
      add :site_id, :integer
    end

    create index(:links, [:site_id])
  end
end
