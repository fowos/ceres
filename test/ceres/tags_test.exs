defmodule Ceres.TagsTest do
alias Ceres.TagsFixtures
alias Ceres.TitlesFixtures
  use Ceres.DataCase

  alias Ceres.Tags

  describe "tags" do
    alias Ceres.Tags.Tag

    import Ceres.TagsFixtures

    @invalid_attrs %{name: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Tags.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Tags.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tag{} = tag} = Tags.create_tag(valid_attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tags.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tag{} = tag} = Tags.update_tag(tag, update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.update_tag(tag, @invalid_attrs)
      assert tag == Tags.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Tags.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Tags.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Tags.change_tag(tag)
    end

    test "get_tag_by_name/1 returns the tag" do
      tag = tag_fixture()
      assert tag == Tags.get_tag_by_name(tag.name)
    end
  end

  describe "titles_tags" do
    alias Ceres.Tags.TitlesTags

    import Ceres.TagsFixtures

    @invalid_attrs %{tag_id: Ecto.UUID.generate(), title_id: Ecto.UUID.generate()}
    @invalid_attrs2 %{title_id: Ecto.UUID.generate()}
    @invalid_attrs3 %{tag_id: Ecto.UUID.generate()}

    test "list_titles_tags/0 returns all titles_tags" do
      titles_tags = titles_tags_fixture()
      assert Tags.list_titles_tags() == [titles_tags]
    end

    test "get_titles_tags!/1 returns the titles_tags with given id" do
      titles_tags = titles_tags_fixture()
      assert Tags.get_titles_tags!(titles_tags.id) == titles_tags
    end

    test "create_titles_tags/1 with valid data creates a titles_tags" do
      title = TitlesFixtures.title_fixture()
      tag = TagsFixtures.tag_fixture()
      valid_attrs = %{title_id: title.id, tag_id: tag.id}

      assert {:ok, %TitlesTags{} = titles_tags} = Tags.create_titles_tags(valid_attrs)
    end

    test "create_titles_tags/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tags.create_titles_tags(@invalid_attrs)
      assert {:error, %Ecto.Changeset{}} = Tags.create_titles_tags(@invalid_attrs2)
    end

    test "update_titles_tags/2 with valid data updates the titles_tags" do
      titles_tags = titles_tags_fixture()
      update_attrs = %{}

      assert {:ok, %TitlesTags{} = titles_tags} = Tags.update_titles_tags(titles_tags, update_attrs)
    end

    test "update_titles_tags/2 with invalid data returns error changeset" do
      titles_tags = titles_tags_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.update_titles_tags(titles_tags, @invalid_attrs)
      assert {:error, %Ecto.Changeset{}} = Tags.update_titles_tags(titles_tags, @invalid_attrs2)
      assert {:error, %Ecto.Changeset{}} = Tags.update_titles_tags(titles_tags, @invalid_attrs3)

      assert titles_tags == Tags.get_titles_tags!(titles_tags.id)
    end

    test "delete_titles_tags/1 deletes the titles_tags" do
      titles_tags = titles_tags_fixture()
      assert {:ok, %TitlesTags{}} = Tags.delete_titles_tags(titles_tags)
      assert_raise Ecto.NoResultsError, fn -> Tags.get_titles_tags!(titles_tags.id) end
    end

    test "change_titles_tags/1 returns a titles_tags changeset" do
      titles_tags = titles_tags_fixture()
      assert %Ecto.Changeset{} = Tags.change_titles_tags(titles_tags)
    end

    test "get_titles_tags_by_ids/2 returns the title_tags" do
      title_tags = titles_tags_fixture()
      assert title_tags == Tags.get_titles_tags_by_ids(title_tags.title_id, title_tags.tag_id)
    end
  end
end
