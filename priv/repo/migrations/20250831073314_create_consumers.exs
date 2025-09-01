defmodule Ceres.Repo.Migrations.CreateConsumers do
  use Ecto.Migration

  def change do
    create table(:consumers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text
      add :public_key, :text, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:consumers, [:public_key])
  end
end
