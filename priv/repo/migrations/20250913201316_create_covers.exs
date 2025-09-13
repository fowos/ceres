defmodule Ceres.Repo.Migrations.CreateCovers do
  use Ecto.Migration

  def change do
    create table(:covers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :source, :text
      add :comic_id, references(:comics, on_delete: :nilify_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:covers, [:comic_id])
  end
end
