defmodule Slink.Repo.Migrations.AddAdminRoleToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :admin_role, :string, comment: "admin role"
    end
  end
end
