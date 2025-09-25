defmodule Ceres.AuthorsTest do
  alias Ceres.Titles
  alias Ceres.AuthorsFixtures
  alias Ceres.TitlesFixtures
  use Ceres.DataCase

  alias Ceres.Authors

  describe "authors" do
    alias Ceres.Authors.Author

    import Ceres.AuthorsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Authors.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Authors.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Author{} = author} = Authors.create_author(valid_attrs)
      assert author.name == "some name"
      assert author.description == "some description"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authors.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Author{} = author} = Authors.update_author(author, update_attrs)
      assert author.name == "some updated name"
      assert author.description == "some updated description"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Authors.update_author(author, @invalid_attrs)
      assert author == Authors.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Authors.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Authors.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Authors.change_author(author)
    end
  end

  describe "publishers" do
    alias Ceres.Authors.Publisher

    import Ceres.AuthorsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_publishers/0 returns all publishers" do
      publisher = publisher_fixture()
      assert Authors.list_publishers() == [publisher]
    end

    test "get_publisher!/1 returns the publisher with given id" do
      publisher = publisher_fixture()
      assert Authors.get_publisher!(publisher.id) == publisher
    end

    test "create_publisher/1 with valid data creates a publisher" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Publisher{} = publisher} = Authors.create_publisher(valid_attrs)
      assert publisher.name == "some name"
      assert publisher.description == "some description"
    end

    test "create_publisher/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authors.create_publisher(@invalid_attrs)
    end

    test "update_publisher/2 with valid data updates the publisher" do
      publisher = publisher_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Publisher{} = publisher} = Authors.update_publisher(publisher, update_attrs)
      assert publisher.name == "some updated name"
      assert publisher.description == "some updated description"
    end

    test "update_publisher/2 with invalid data returns error changeset" do
      publisher = publisher_fixture()
      assert {:error, %Ecto.Changeset{}} = Authors.update_publisher(publisher, @invalid_attrs)
      assert publisher == Authors.get_publisher!(publisher.id)
    end

    test "delete_publisher/1 deletes the publisher" do
      publisher = publisher_fixture()
      assert {:ok, %Publisher{}} = Authors.delete_publisher(publisher)
      assert_raise Ecto.NoResultsError, fn -> Authors.get_publisher!(publisher.id) end
    end

    test "change_publisher/1 returns a publisher changeset" do
      publisher = publisher_fixture()
      assert %Ecto.Changeset{} = Authors.change_publisher(publisher)
    end
  end

  describe "authors_titles" do
    alias Ceres.Authors.AuthorsTitles

    import Ceres.AuthorsFixtures
    import Ceres.TitlesFixtures

    @invalid_attrs %{author_role: nil}

    test "list_authors_titles/0 returns all authors_titles" do
      authors_titles = authors_titles_fixture()
      assert Authors.list_authors_titles() == [authors_titles]
    end

    test "get_authors_titles!/1 returns the authors_titles with given id" do
      authors_titles = authors_titles_fixture()
      assert Authors.get_authors_titles!(authors_titles.id) == authors_titles
    end

    test "create_authors_titles/1 with valid data creates a authors_titles" do
      valid_attrs = %{author_role: :story}

      assert %AuthorsTitles{} = authors_titles= authors_titles_fixture(valid_attrs)
      assert authors_titles.author_role == :story
    end

    test "create_authors_titles/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authors.create_authors_titles(@invalid_attrs)
    end

    test "update_authors_titles/2 with valid data updates the authors_titles" do
      authors_titles = authors_titles_fixture()
      update_attrs = %{author_role: :story_art}

      assert {:ok, %AuthorsTitles{} = authors_titles} = Authors.update_authors_titles(authors_titles, update_attrs)
      assert authors_titles.author_role == :story_art
    end

    test "update_authors_titles/2 with invalid data returns error changeset" do
      authors_titles = authors_titles_fixture()
      assert {:error, %Ecto.Changeset{}} = Authors.update_authors_titles(authors_titles, @invalid_attrs)
      assert authors_titles == Authors.get_authors_titles!(authors_titles.id)
    end

    test "delete_authors_titles/1 deletes the authors_titles" do
      authors_titles = authors_titles_fixture()
      assert {:ok, %AuthorsTitles{}} = Authors.delete_authors_titles(authors_titles)
      assert_raise Ecto.NoResultsError, fn -> Authors.get_authors_titles!(authors_titles.id) end
    end

    test "change_authors_titles/1 returns a authors_titles changeset" do
      authors_titles = authors_titles_fixture()
      assert %Ecto.Changeset{} = Authors.change_authors_titles(authors_titles)
    end
  end

  describe "publishers_titles" do
    alias Ceres.Authors.PublishersTitles

    import Ceres.AuthorsFixtures

    @invalid_attrs %{title_id: 12, publisher_id: 13}

    test "list_publishers_titles/0 returns all publishers_titles" do
      publishers_titles = publishers_titles_fixture()
      assert Authors.list_publishers_titles() == [publishers_titles]
    end

    test "get_publishers_titles!/1 returns the publishers_titles with given id" do
      publishers_titles = publishers_titles_fixture()
      assert Authors.get_publishers_titles!(publishers_titles.id) == publishers_titles
    end

    test "create_publishers_titles/1 with valid data creates a publishers_titles" do
      valid_attrs = %{}

      assert %PublishersTitles{} = publishers_titles_fixture()
    end

    test "create_publishers_titles/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authors.create_publishers_titles(@invalid_attrs)
    end

    test "update_publishers_titles/2 with valid data updates the publishers_titles" do
      publishers_titles = publishers_titles_fixture()
      update_attrs = %{}

      assert {:ok, %PublishersTitles{}} = Authors.update_publishers_titles(publishers_titles, update_attrs)
    end

    test "update_publishers_titles/2 with invalid data returns error changeset" do
      publishers_titles = publishers_titles_fixture()
      assert {:error, %Ecto.Changeset{}} = Authors.update_publishers_titles(publishers_titles, @invalid_attrs)
      assert publishers_titles == Authors.get_publishers_titles!(publishers_titles.id)
    end

    test "delete_publishers_titles/1 deletes the publishers_titles" do
      publishers_titles = publishers_titles_fixture()
      assert {:ok, %PublishersTitles{}} = Authors.delete_publishers_titles(publishers_titles)
      assert_raise Ecto.NoResultsError, fn -> Authors.get_publishers_titles!(publishers_titles.id) end
    end

    test "change_publishers_titles/1 returns a publishers_titles changeset" do
      publishers_titles = publishers_titles_fixture()
      assert %Ecto.Changeset{} = Authors.change_publishers_titles(publishers_titles)
    end
  end
end
