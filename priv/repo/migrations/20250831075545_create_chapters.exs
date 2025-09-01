defmodule Ceres.Repo.Migrations.CreateChapters do
  use Ecto.Migration

  def change do
    create table(:chapters, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :volume, :integer, null: true
      add :number, :integer, null: true
      add :comic_id, references(:comics, on_delete: :delete_all, type: :binary_id), null: true

      timestamps(type: :utc_datetime)
    end

    create index(:chapters, [:comic_id])
    create index(:chapters, [:volume])
    create index(:chapters, [:number])
  end
end
