defmodule Ceres.Repo.Migrations.CreatePublishers do
  use Ecto.Migration

  def change do
    create table(:publishers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create index(:publishers, [:name])
  end
end
