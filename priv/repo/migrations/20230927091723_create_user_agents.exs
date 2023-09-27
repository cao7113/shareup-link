defmodule Slink.Repo.Migrations.CreateUserAgents do
  use Ecto.Migration

  def change do
    create table(:user_agents) do
      add :label, :string
      add :agent, :text
      add :last_user_id, :integer
      add :last_ip, :string
      add :note, :string

      timestamps()
    end

    create index(:user_agents, [:last_user_id])
  end
end
