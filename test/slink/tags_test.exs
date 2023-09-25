defmodule Slink.TagsTest do
  use Slink.DataCase

  alias Slink.Tags

  describe "auto match" do
    @tag :manual
    test "ok" do
      str = "
      公安部：持续深化户籍制度改革 进一步放宽集体户设立条件_新闻频道_中国青年网
      https://news.youth.cn/gn/202308/t20230803_14693492.htm"

      words = ~w[户籍 公安部 youth] |> Enum.join("|")

      matches =
        Regex.scan(~r/(#{words})/i, str, capture: :all_but_first)
        |> List.flatten()
        |> Enum.uniq()

      assert matches == ["公安部", "户籍", "youth"]
    end
  end

  describe "tags" do
    alias Slink.Tags.Tag

    import Slink.TagsFixtures

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
  end
end
