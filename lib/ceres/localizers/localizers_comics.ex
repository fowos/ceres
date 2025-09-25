defmodule Ceres.Localizers.LocalizersComics do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "localizers_comics" do

    belongs_to :comic, Ceres.Titles.Comic, type: :binary_id
    belongs_to :localizer, Ceres.Localizers.Localizer, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(localizers_comics, attrs) do
    localizers_comics
    |> cast(attrs, [:comic_id, :localizer_id])
    |> validate_required([:comic_id, :localizer_id])
    |> unique_constraint(:comic_id, name: :localizers_comics_comic_id_localizer_id_index)
    |> foreign_key_constraint(:comic_id, name: :localizers_comics_comic_id_fkey)
    |> foreign_key_constraint(:localizer_id, name: :localizers_comics_localizer_id_fkey)
  end
end
