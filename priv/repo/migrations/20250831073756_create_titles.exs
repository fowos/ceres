defmodule Ceres.Repo.Migrations.CreateTitles do
  use Ecto.Migration

  def change do
    create table(:titles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :original_name, :text, null: false
      add :type, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:titles, [:type])
    create unique_index(:titles, [:original_name])
  end
end
