defmodule Ceres.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :number, :integer, null: false
      add :source, :text, null: false
      add :chapter_id, references(:chapters, on_delete: :nilify_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:pages, [:chapter_id])
  end
end
