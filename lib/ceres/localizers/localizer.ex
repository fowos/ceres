defmodule Ceres.Localizers.Localizer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "localizers" do
    field :name, :string
    field :description, :string

    has_many :localizers_comics, Ceres.Localizers.LocalizersComics
    has_many :titles, through: [:localizers_comics, :comic]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(localizer, attrs) do
    localizer
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
