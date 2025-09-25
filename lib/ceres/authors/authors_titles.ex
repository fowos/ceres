defmodule Ceres.Authors.AuthorsTitles do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "authors_titles" do
    field :author_role, Ecto.Enum, values: [art: 0, story: 1, story_art: 2], embed_as: :dumped
    belongs_to :author, Ceres.Authors.Author, type: :binary_id
    belongs_to :title, Ceres.Titles.Title, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(authors_titles, attrs) do
    authors_titles
    |> cast(attrs, [:author_role, :author_id, :title_id])
    |> validate_required([:author_role, :author_id, :title_id])
    |> foreign_key_constraint(:title_id, name: :authors_titles_title_id_fkey)
  end
end
