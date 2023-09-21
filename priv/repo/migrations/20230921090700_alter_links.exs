defmodule Slink.Repo.Migrations.AlterLinks do
  use Ecto.Migration

  def up do
    alter table(:links) do
      modify :url, :string, null: false, size: 400
    end
  end

  def down do
    alter table(:links) do
      modify :url, :string, size: 400
    end
  end
end
