defmodule Ceres.Tags.TitlesTags do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "titles_tags" do

    belongs_to :title, Ceres.Titles.Title, type: :binary_id
    belongs_to :tag, Ceres.Tags.Tag, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(titles_tags, attrs) do
    titles_tags
    |> cast(attrs, [:title_id, :tag_id])
    |> validate_required([:title_id, :tag_id])
    |> unique_constraint([:title_id, :tag_id])
    |> foreign_key_constraint(:title_id, name: :titles_tags_title_id_fkey)
    |> foreign_key_constraint(:tag_id, name: :titles_tags_tag_id_fkey)
  end
end
