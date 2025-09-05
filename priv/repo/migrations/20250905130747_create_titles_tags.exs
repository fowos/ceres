defmodule Ceres.Repo.Migrations.CreateTitlesTags do
  use Ecto.Migration

  def change do
    create table(:titles_tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title_id, references(:titles, on_delete: :nothing, type: :binary_id), null: false
      add :tag_id, references(:tags, on_delete: :nothing, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:titles_tags, [:title_id])
    create index(:titles_tags, [:tag_id])

    create unique_index(:titles_tags, [:title_id, :tag_id])
  end
end
