defmodule Slink.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add(:name, :citext, null: false, limit: 30)
      add(:auto_match_touch_at, :utc_datetime, comment: "time to auto match by bot")
      add(:pin_top_touch_at, :utc_datetime, comment: "time to pin top")

      timestamps()
    end

    create(unique_index(:tags, [:name]))
    create(index(:tags, :auto_match_touch_at))
    create(index(:tags, :pin_top_touch_at))

    alter table(:links) do
      add(:tags, {:array, :string}, default: [])
    end

    create(index(:links, :tags))
  end
end
