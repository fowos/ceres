defmodule Ceres.Authors.PublishersTitles do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "publishers_titles" do

    belongs_to :publisher, Ceres.Authors.Publisher, type: :binary_id
    belongs_to :title, Ceres.Titles.Title, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(publishers_titles, attrs) do
    publishers_titles
    |> cast(attrs, [:publisher_id, :title_id])
    |> validate_required([:publisher_id, :title_id])
    |> unique_constraint(:title_id, name: :unique_publisher_title)
  end
end
