defmodule Slink.LinksTest do
  use Slink.DataCase

  alias Slink.Links

  describe "links" do
    alias Slink.Links.Link

    import Slink.LinksFixtures

    @some_url "http://a.b/some-url"
    @some_update_url "http://a.b/some-updated-url"
    @invalid_attrs %{title: nil, url: nil}

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Links.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{title: "some title", url: @some_url}

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)
      assert link.title == "some title"
      assert link.url == @some_url

      # create again
      {:error,
       %{
         action: :insert,
         changes: %{title: "some title", url: @some_url},
         errors: [
           url:
             {"has already been taken", [constraint: :unique, constraint_name: "links_url_index"]}
         ],
         valid?: false
       }} = Links.create_link(valid_attrs)
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    @tag :manual
    test "create_links" do
      [
        params_for(:link),
        params_for(:link)
      ]
      |> Links.create_links()
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      update_attrs = %{title: "some updated title", url: @some_update_url}

      assert {:ok, %Link{} = link} = Links.update_link(link, update_attrs)
      assert link.title == "some updated title"
      assert link.url == @some_update_url
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link == Links.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Links.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Links.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end
  end
end
