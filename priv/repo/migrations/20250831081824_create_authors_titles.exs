defmodule Ceres.Repo.Migrations.CreateAuthorsTitles do
  use Ecto.Migration

  def change do
    create table(:authors_titles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :author_role, :integer, null: false
      add :author_id, references(:authors, on_delete: :delete_all, type: :binary_id), null: false
      add :title_id, references(:titles, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:authors_titles, [:author_id])
    create index(:authors_titles, [:title_id])
    create unique_index(:authors_titles, [:author_id, :title_id], name: :authors_titles_author_id_title_id_index)
  end
end
