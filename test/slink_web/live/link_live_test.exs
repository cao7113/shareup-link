defmodule SlinkWeb.LinkLiveTest do
  use SlinkWeb.ConnCase

  import Phoenix.LiveViewTest
  import Slink.LinksFixtures
  import Slink.AccountsFixtures

  @create_attrs %{title: "some title", url: "http://a.b/some-url"}
  @update_attrs %{title: "some updated title", url: "http://a.b/some-updated-url"}
  @invalid_attrs %{title: nil, url: nil}

  defp create_link(_) do
    link = link_fixture()
    %{link: link}
  end

  describe "Index" do
    setup [:create_link, :register_and_log_in_user]

    test "lists all links", %{conn: conn, link: link} do
      {:ok, _index_live, html} = live(conn, ~p"/links")

      assert html =~ "Listing Links"
      assert html =~ link.title
    end

    test "saves new link", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/links")

      assert index_live |> element("a", "New Link") |> render_click() =~
               "New Link"

      assert_patch(index_live, ~p"/links/new")

      assert index_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#link-form", link: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/links")

      html = render(index_live)
      # assert html =~ "Link created successfully"
      assert html =~ "some title"
    end

    test "updates link in listing", %{conn: conn, link: link} do
      {:ok, index_live, _html} = live(conn, ~p"/links")

      assert index_live |> element("#links-#{link.id} a", "Edit") |> render_click() =~
               "Edit Link"

      assert_patch(index_live, ~p"/links/#{link}/edit")

      assert index_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#link-form", link: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/links")

      html = render(index_live)
      # todo
      # assert html =~ "Link updated successfully"
      assert html =~ "some updated title"
    end

    # TODO
    # test "deletes link in listing", %{conn: conn, link: link} do
    #   {:ok, index_live, _html} = live(conn, ~p"/links")

    #   assert index_live |> element("#links-#{link.id} a", "Delete") |> render_click()
    #   refute has_element?(index_live, "#links-#{link.id}")
    # end
  end

  describe "Show" do
    setup [:create_link, :register_and_log_in_user]

    test "displays link", %{conn: conn, link: link} do
      {:ok, _show_live, html} = live(conn, ~p"/links/#{link}")

      assert html =~ "Show Link"
      assert html =~ link.title
    end

    test "updates link within modal", %{conn: conn, link: link} do
      {:ok, show_live, _html} = live(conn, ~p"/links/#{link}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Link"

      assert_patch(show_live, ~p"/links/#{link}/show/edit")

      assert show_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#link-form", link: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/links/#{link}")

      html = render(show_live)
      assert html =~ "Link updated successfully"
      assert html =~ "some updated title"
    end
  end
end
