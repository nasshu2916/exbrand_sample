defmodule ExbrandSample.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :user_id, :integer, null: false
      add :email, :string, null: false
      add :nickname, :string, null: false
      add :status, :string, null: false, default: "invited"

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:user_id])
    create unique_index(:users, [:email])
  end
end
