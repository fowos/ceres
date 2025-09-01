defmodule Ceres.Consumers.Consumer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "consumers" do
    field :name, :string
    field :public_key, :string

    has_many :comments, Ceres.Consumers.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(consumer, attrs) do
    consumer
    |> cast(attrs, [:name, :public_key])
    |> validate_required([:name, :public_key])
    |> unique_constraint(:public_key)
  end
end
