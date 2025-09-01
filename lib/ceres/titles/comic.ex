defmodule Ceres.Titles.Comic do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comics" do
    field :name, :string
    field :description, :string
    field :language, Ecto.Enum, values: [en: 0, jp: 1, kr: 2, cn: 3, ru: 4], embed_as: :dumped

    belongs_to :title, Ceres.Titles.Title, type: :binary_id

    has_many :chapters, Ceres.Titles.Chapter

    has_many :localizers_comics, Ceres.Localizers.LocalizersComics
    has_many :localizers, through: [:localizers_comics, :localizer]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comic, attrs) do
    comic
    |> cast(attrs, [:name, :description, :language, :title_id])
    |> validate_required([:name, :description, :language, :title_id])
  end
end
