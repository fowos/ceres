defmodule Ceres.Repo.Migrations.CreateComics do
  use Ecto.Migration

  def change do
    create table(:comics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text, null: false
      add :description, :text
      add :language, :integer, null: false
      add :title_id, references(:titles, on_delete: :delete_all, type: :binary_id), null: true

      timestamps(type: :utc_datetime)
    end

    create index(:comics, [:title_id])
    create index(:comics, [:name])
    create index(:comics, [:language])
  end
end
