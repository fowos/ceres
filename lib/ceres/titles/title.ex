defmodule Ceres.Titles.Title do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "titles" do
    field :original_name, :string
    field :type, Ecto.Enum, values: [manga: 0, manhwa: 1, comic: 2, novel: 3], embed_as: :dumped

    has_many :comics, Ceres.Titles.Comic

    has_many :authors_titles, Ceres.Authors.AuthorsTitles
    has_many :authors, through: [:authors_titles, :author]

    # has_many :publishers_titles, Ceres.Authors.PublishersTitles
    # has_many :publishers, through: [:publishers_titles, :publisher]

    many_to_many :publishers, Ceres.Authors.Publisher, join_through: Ceres.Authors.PublishersTitles
    many_to_many :tags, Ceres.Tags.Tag, join_through: Ceres.Tags.TitlesTags


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(title, attrs) do
    title
    |> cast(attrs, [:original_name, :type])
    |> validate_required([:original_name, :type])
    |> unique_constraint(:original_name)
  end
end
