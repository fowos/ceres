defmodule Ceres.Repo.Migrations.CreateLocalizers do
  use Ecto.Migration

  def change do
    create table(:localizers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:localizers, [:name])
  end
end
