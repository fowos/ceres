defmodule Ceres.Titles.Cover do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "covers" do
    field :source, :string
    belongs_to :comic, Ceres.Titles.Comic, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cover, attrs) do
    cover
    |> cast(attrs, [:source, :comic_id])
    |> validate_required([:source, :comic_id])
  end
end
