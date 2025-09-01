defmodule Ceres.Titles.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chapters" do
    field :volume, :integer
    field :number, :integer
    belongs_to :comic, Ceres.Titles.Comic, type: :binary_id

    has_many :pages, Ceres.Titles.Page

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chapter, attrs) do
    chapter
    |> cast(attrs, [:volume, :number, :comic_id])
    |> validate_required([:volume, :number, :comic_id])
  end
end
