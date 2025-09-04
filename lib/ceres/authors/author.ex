defmodule Ceres.Authors.Author do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "authors" do
    field :name, :string
    field :description, :string

    has_many :author_titles, Ceres.Authors.AuthorsTitles
    has_many :titles, through: [:author_titles, :title]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
