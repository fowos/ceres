defmodule Ceres.LocalizersTest do
alias Ceres.TitlesFixtures
  use Ceres.DataCase

  alias Ceres.Localizers

  describe "localizers" do
    alias Ceres.Localizers.Localizer

    import Ceres.LocalizersFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_localizers/0 returns all localizers" do
      localizer = localizer_fixture()
      assert Localizers.list_localizers() == [localizer]
    end

    test "get_localizer!/1 returns the localizer with given id" do
      localizer = localizer_fixture()
      assert Localizers.get_localizer!(localizer.id) == localizer
    end

    test "create_localizer/1 with valid data creates a localizer" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Localizer{} = localizer} = Localizers.create_localizer(valid_attrs)
      assert localizer.name == "some name"
      assert localizer.description == "some description"
    end

    test "create_localizer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Localizers.create_localizer(@invalid_attrs)
    end

    test "update_localizer/2 with valid data updates the localizer" do
      localizer = localizer_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Localizer{} = localizer} = Localizers.update_localizer(localizer, update_attrs)
      assert localizer.name == "some updated name"
      assert localizer.description == "some updated description"
    end

    test "update_localizer/2 with invalid data returns error changeset" do
      localizer = localizer_fixture()
      assert {:error, %Ecto.Changeset{}} = Localizers.update_localizer(localizer, @invalid_attrs)
      assert localizer == Localizers.get_localizer!(localizer.id)
    end

    test "delete_localizer/1 deletes the localizer" do
      localizer = localizer_fixture()
      assert {:ok, %Localizer{}} = Localizers.delete_localizer(localizer)
      assert_raise Ecto.NoResultsError, fn -> Localizers.get_localizer!(localizer.id) end
    end

    test "change_localizer/1 returns a localizer changeset" do
      localizer = localizer_fixture()
      assert %Ecto.Changeset{} = Localizers.change_localizer(localizer)
    end
  end

  describe "localizers_comics" do
    alias Ceres.Localizers.LocalizersComics

    import Ceres.LocalizersFixtures

    @invalid_attrs %{comic_id: Ecto.UUID.generate(), localizer_id: Ecto.UUID.generate()}
    @invalid_attrs2 %{localizer_id: Ecto.UUID.generate()}
    @invalid_attrs3 %{comic_id: Ecto.UUID.generate()}

    test "list_localizers_comics/0 returns all localizers_comics" do
      localizers_comics = localizers_comics_fixture()
      assert Localizers.list_localizers_comics() == [localizers_comics]
    end

    test "get_localizers_comics!/1 returns the localizers_comics with given id" do
      localizers_comics = localizers_comics_fixture()
      assert Localizers.get_localizers_comics!(localizers_comics.id) == localizers_comics
    end

    test "create_localizers_comics/1 with valid data creates a localizers_comics" do
      title = TitlesFixtures.title_fixture()
      comic = TitlesFixtures.comic_fixture(%{title_id: title.id})
      local = localizer_fixture()

      valid_attrs = %{title_id: title.id, comic_id: comic.id, localizer_id: local.id}

      assert {:ok, %LocalizersComics{} = localizers_comics} = Localizers.create_localizers_comics(valid_attrs)
    end

    test "create_localizers_comics/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Localizers.create_localizers_comics(@invalid_attrs)
    end

    test "update_localizers_comics/2 with valid data updates the localizers_comics" do
      localizers_comics = localizers_comics_fixture()
      update_attrs = %{}

      assert {:ok, %LocalizersComics{} = localizers_comics} = Localizers.update_localizers_comics(localizers_comics, update_attrs)
    end

    test "update_localizers_comics/2 with invalid data returns error changeset" do
      localizers_comics = localizers_comics_fixture()
      assert {:error, %Ecto.Changeset{}} = Localizers.update_localizers_comics(localizers_comics, @invalid_attrs)
      assert {:error, %Ecto.Changeset{}} = Localizers.update_localizers_comics(localizers_comics, @invalid_attrs2)
      assert {:error, %Ecto.Changeset{}} = Localizers.update_localizers_comics(localizers_comics, @invalid_attrs3)

      assert localizers_comics == Localizers.get_localizers_comics!(localizers_comics.id)
    end

    test "delete_localizers_comics/1 deletes the localizers_comics" do
      localizers_comics = localizers_comics_fixture()
      assert {:ok, %LocalizersComics{}} = Localizers.delete_localizers_comics(localizers_comics)
      assert_raise Ecto.NoResultsError, fn -> Localizers.get_localizers_comics!(localizers_comics.id) end
    end

    test "change_localizers_comics/1 returns a localizers_comics changeset" do
      localizers_comics = localizers_comics_fixture()
      assert %Ecto.Changeset{} = Localizers.change_localizers_comics(localizers_comics)
    end
  end
end
