defmodule Ceres.TitlesTest do
  use Ceres.DataCase

  alias Ceres.Titles

  describe "titles" do
    alias Ceres.Titles.Title

    import Ceres.AccountsFixtures, only: [user_scope_fixture: 0]
    import Ceres.TitlesFixtures

    @invalid_attrs %{type: nil, original_name: nil}

    test "list_titles/1 returns all scoped titles" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      title = title_fixture(scope)
      other_title = title_fixture(other_scope)
      assert Titles.list_titles(scope) == [title]
      assert Titles.list_titles(other_scope) == [other_title]
    end

    test "get_title!/2 returns the title with given id" do
      scope = user_scope_fixture()
      title = title_fixture(scope)
      other_scope = user_scope_fixture()
      assert Titles.get_title!(scope, title.id) == title
      assert_raise Ecto.NoResultsError, fn -> Titles.get_title!(other_scope, title.id) end
    end

    test "create_title/2 with valid data creates a title" do
      valid_attrs = %{type: 42, original_name: "some original_name"}
      scope = user_scope_fixture()

      assert {:ok, %Title{} = title} = Titles.create_title(scope, valid_attrs)
      assert title.type == 42
      assert title.original_name == "some original_name"
      assert title.user_id == scope.user.id
    end

    test "create_title/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Titles.create_title(scope, @invalid_attrs)
    end

    test "update_title/3 with valid data updates the title" do
      scope = user_scope_fixture()
      title = title_fixture(scope)
      update_attrs = %{type: 43, original_name: "some updated original_name"}

      assert {:ok, %Title{} = title} = Titles.update_title(scope, title, update_attrs)
      assert title.type == 43
      assert title.original_name == "some updated original_name"
    end

    test "update_title/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      title = title_fixture(scope)

      assert_raise MatchError, fn ->
        Titles.update_title(other_scope, title, %{})
      end
    end

    test "update_title/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      title = title_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Titles.update_title(scope, title, @invalid_attrs)
      assert title == Titles.get_title!(scope, title.id)
    end

    test "delete_title/2 deletes the title" do
      scope = user_scope_fixture()
      title = title_fixture(scope)
      assert {:ok, %Title{}} = Titles.delete_title(scope, title)
      assert_raise Ecto.NoResultsError, fn -> Titles.get_title!(scope, title.id) end
    end

    test "delete_title/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      title = title_fixture(scope)
      assert_raise MatchError, fn -> Titles.delete_title(other_scope, title) end
    end

    test "change_title/2 returns a title changeset" do
      scope = user_scope_fixture()
      title = title_fixture(scope)
      assert %Ecto.Changeset{} = Titles.change_title(scope, title)
    end
  end

  describe "comics" do
    alias Ceres.Titles.Comic

    import Ceres.TitlesFixtures

    @invalid_attrs %{name: nil, description: nil, language: nil, views: nil}

    test "list_comics/0 returns all comics" do
      comic = comic_fixture()
      assert Titles.list_comics() == [comic]
    end

    test "get_comic!/1 returns the comic with given id" do
      comic = comic_fixture()
      assert Titles.get_comic!(comic.id) == comic
    end

    test "create_comic/1 with valid data creates a comic" do
      valid_attrs = %{name: "some name", description: "some description", language: 42, views: 42}

      assert {:ok, %Comic{} = comic} = Titles.create_comic(valid_attrs)
      assert comic.name == "some name"
      assert comic.description == "some description"
      assert comic.language == 42
      assert comic.views == 42
    end

    test "create_comic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Titles.create_comic(@invalid_attrs)
    end

    test "update_comic/2 with valid data updates the comic" do
      comic = comic_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", language: 43, views: 43}

      assert {:ok, %Comic{} = comic} = Titles.update_comic(comic, update_attrs)
      assert comic.name == "some updated name"
      assert comic.description == "some updated description"
      assert comic.language == 43
      assert comic.views == 43
    end

    test "update_comic/2 with invalid data returns error changeset" do
      comic = comic_fixture()
      assert {:error, %Ecto.Changeset{}} = Titles.update_comic(comic, @invalid_attrs)
      assert comic == Titles.get_comic!(comic.id)
    end

    test "delete_comic/1 deletes the comic" do
      comic = comic_fixture()
      assert {:ok, %Comic{}} = Titles.delete_comic(comic)
      assert_raise Ecto.NoResultsError, fn -> Titles.get_comic!(comic.id) end
    end

    test "change_comic/1 returns a comic changeset" do
      comic = comic_fixture()
      assert %Ecto.Changeset{} = Titles.change_comic(comic)
    end
  end

  describe "chapters" do
    alias Ceres.Titles.Chapter

    import Ceres.TitlesFixtures

    @invalid_attrs %{number: nil, volume: nil}

    test "list_chapters/0 returns all chapters" do
      chapter = chapter_fixture()
      assert Titles.list_chapters() == [chapter]
    end

    test "get_chapter!/1 returns the chapter with given id" do
      chapter = chapter_fixture()
      assert Titles.get_chapter!(chapter.id) == chapter
    end

    test "create_chapter/1 with valid data creates a chapter" do
      valid_attrs = %{number: 42, volume: 42}

      assert {:ok, %Chapter{} = chapter} = Titles.create_chapter(valid_attrs)
      assert chapter.number == 42
      assert chapter.volume == 42
    end

    test "create_chapter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Titles.create_chapter(@invalid_attrs)
    end

    test "update_chapter/2 with valid data updates the chapter" do
      chapter = chapter_fixture()
      update_attrs = %{number: 43, volume: 43}

      assert {:ok, %Chapter{} = chapter} = Titles.update_chapter(chapter, update_attrs)
      assert chapter.number == 43
      assert chapter.volume == 43
    end

    test "update_chapter/2 with invalid data returns error changeset" do
      chapter = chapter_fixture()
      assert {:error, %Ecto.Changeset{}} = Titles.update_chapter(chapter, @invalid_attrs)
      assert chapter == Titles.get_chapter!(chapter.id)
    end

    test "delete_chapter/1 deletes the chapter" do
      chapter = chapter_fixture()
      assert {:ok, %Chapter{}} = Titles.delete_chapter(chapter)
      assert_raise Ecto.NoResultsError, fn -> Titles.get_chapter!(chapter.id) end
    end

    test "change_chapter/1 returns a chapter changeset" do
      chapter = chapter_fixture()
      assert %Ecto.Changeset{} = Titles.change_chapter(chapter)
    end
  end

  describe "pages" do
    alias Ceres.Titles.Page

    import Ceres.TitlesFixtures

    @invalid_attrs %{number: nil, source: nil}

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert Titles.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Titles.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      valid_attrs = %{number: 42, source: "some source"}

      assert {:ok, %Page{} = page} = Titles.create_page(valid_attrs)
      assert page.number == 42
      assert page.source == "some source"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Titles.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      update_attrs = %{number: 43, source: "some updated source"}

      assert {:ok, %Page{} = page} = Titles.update_page(page, update_attrs)
      assert page.number == 43
      assert page.source == "some updated source"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Titles.update_page(page, @invalid_attrs)
      assert page == Titles.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Titles.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Titles.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Titles.change_page(page)
    end
  end

  describe "covers" do
    alias Ceres.Titles.Cover

    import Ceres.TitlesFixtures

    @invalid_attrs %{source: nil}

    test "list_covers/0 returns all covers" do
      cover = cover_fixture()
      assert Titles.list_covers() == [cover]
    end

    test "get_cover!/1 returns the cover with given id" do
      cover = cover_fixture()
      assert Titles.get_cover!(cover.id) == cover
    end

    test "create_cover/1 with valid data creates a cover" do
      valid_attrs = %{source: "some source"}

      assert {:ok, %Cover{} = cover} = Titles.create_cover(valid_attrs)
      assert cover.source == "some source"
    end

    test "create_cover/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Titles.create_cover(@invalid_attrs)
    end

    test "update_cover/2 with valid data updates the cover" do
      cover = cover_fixture()
      update_attrs = %{source: "some updated source"}

      assert {:ok, %Cover{} = cover} = Titles.update_cover(cover, update_attrs)
      assert cover.source == "some updated source"
    end

    test "update_cover/2 with invalid data returns error changeset" do
      cover = cover_fixture()
      assert {:error, %Ecto.Changeset{}} = Titles.update_cover(cover, @invalid_attrs)
      assert cover == Titles.get_cover!(cover.id)
    end

    test "delete_cover/1 deletes the cover" do
      cover = cover_fixture()
      assert {:ok, %Cover{}} = Titles.delete_cover(cover)
      assert_raise Ecto.NoResultsError, fn -> Titles.get_cover!(cover.id) end
    end

    test "change_cover/1 returns a cover changeset" do
      cover = cover_fixture()
      assert %Ecto.Changeset{} = Titles.change_cover(cover)
    end
  end
end
