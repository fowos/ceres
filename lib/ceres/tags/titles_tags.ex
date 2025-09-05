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
  end
end
