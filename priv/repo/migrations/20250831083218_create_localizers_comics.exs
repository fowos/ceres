defmodule Ceres.Repo.Migrations.CreateLocalizersComics do
  use Ecto.Migration

  def change do
    create table(:localizers_comics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :comic_id, references(:comics, on_delete: :nothing, type: :binary_id), null: false
      add :localizer_id, references(:localizers, on_delete: :nothing, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:localizers_comics, [:comic_id])
    create index(:localizers_comics, [:localizer_id])
    create unique_index(:localizers_comics, [:comic_id, :localizer_id], name: :localizers_comics_comic_id_localizer_id_index)
  end
end
