defmodule Slink.Repo.Migrations.EnsureCitext do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS citext")
  end

  def down do
    # nothing to do
  end
end
