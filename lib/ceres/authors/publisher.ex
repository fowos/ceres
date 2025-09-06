defmodule Ceres.Authors.Publisher do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "publishers" do
    field :name, :string
    field :description, :string

    has_many :publishers_titles, Ceres.Authors.PublishersTitles
    has_many :titles, through: [:publishers_titles, :title]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(publisher, attrs) do
    publisher
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
