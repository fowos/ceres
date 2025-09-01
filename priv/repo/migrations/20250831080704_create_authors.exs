defmodule Ceres.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create index(:authors, [:name])
  end
end
