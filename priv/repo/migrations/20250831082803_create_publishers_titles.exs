defmodule Ceres.Repo.Migrations.CreatePublishersTitles do
  use Ecto.Migration

  def change do
    create table(:publishers_titles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :publisher_id, references(:publishers, on_delete: :delete_all, type: :binary_id), null: false
      add :title_id, references(:titles, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:publishers_titles, [:publisher_id])
    create index(:publishers_titles, [:title_id])
    create unique_index(:publishers_titles, [:publisher_id, :title_id], name: :unique_publisher_title)
  end
end
