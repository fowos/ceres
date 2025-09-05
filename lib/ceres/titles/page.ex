defmodule Ceres.Titles.Page do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pages" do
    field :number, :integer
    field :source, :string
    belongs_to :chapter, Ceres.Titles.Chapter, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:number, :source, :chapter_id])
    |> validate_required([:number, :source, :chapter_id])
    |> unique_constraint(:number, name: :unique_chapter_page_number)
  end
end
