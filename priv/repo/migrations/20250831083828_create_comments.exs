defmodule Ceres.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :text, null: false
      add :title_id, references(:titles, on_delete: :delete_all, type: :binary_id), null: false
      add :consumer_id, references(:consumers, on_delete: :nilify_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:title_id])
    create index(:comments, [:consumer_id])
  end
end
