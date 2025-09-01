defmodule Ceres.Consumers.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :text, :string

    belongs_to :title, Ceres.Titles.Title, type: :binary_id
    belongs_to :consumer, Ceres.Consumers.Consumer, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text, :title_id, :consumer_id])
    |> validate_required([:text, :title_id, :consumer_id])
  end
end
