defmodule Ceres.Localizers.Localizer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "localizers" do
    field :name, :string
    field :description, :string

    has_many :localizers_titles, Ceres.Localizers.LocalizersTitles
    has_many :titles, through: [:localizers_titles, :comic]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(localizer, attrs) do
    localizer
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
