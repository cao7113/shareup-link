defmodule SlinkWeb.NoteLiveTest do
  use SlinkWeb.ConnCase

  import Phoenix.LiveViewTest
  import Slink.NotesFixtures

  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  defp create_note(_) do
    note = note_fixture()
    %{note: note}
  end

  describe "Index" do
    setup [:create_note]

    test "lists all notes", %{conn: conn, note: note} do
      {:ok, _index_live, html} = live(conn, ~p"/notes")

      assert html =~ "Listing Notes"
      assert html =~ note.content
    end

    # test "saves new note", %{conn: conn} do
    #   {:ok, index_live, _html} = live(conn, ~p"/notes")

    #   assert index_live |> element("a", "New Note") |> render_click() =~
    #            "New Note"

    #   assert_patch(index_live, ~p"/notes/new")

    #   assert index_live
    #          |> form("#note-form", note: @invalid_attrs)
    #          |> render_change() =~ "can&#39;t be blank"

    #   assert index_live
    #          |> form("#note-form", note: @create_attrs)
    #          |> render_submit()

    #   assert_patch(index_live, ~p"/notes")

    #   html = render(index_live)
    #   assert html =~ "Note created successfully"
    #   assert html =~ "some content"
    # end

    # test "updates note in listing", %{conn: conn, note: note} do
    #   {:ok, index_live, _html} = live(conn, ~p"/notes")

    #   assert index_live |> element("#notes-#{note.id} a", "Edit") |> render_click() =~
    #            "Edit Note"

    #   assert_patch(index_live, ~p"/notes/#{note}/edit")

    #   assert index_live
    #          |> form("#note-form", note: @invalid_attrs)
    #          |> render_change() =~ "can&#39;t be blank"

    #   assert index_live
    #          |> form("#note-form", note: @update_attrs)
    #          |> render_submit()

    #   assert_patch(index_live, ~p"/notes")

    #   html = render(index_live)
    #   assert html =~ "Note updated successfully"
    #   assert html =~ "some updated content"
    # end

    # test "deletes note in listing", %{conn: conn, note: note} do
    #   {:ok, index_live, _html} = live(conn, ~p"/notes")

    #   assert index_live |> element("#notes-#{note.id} a", "Delete") |> render_click()
    #   refute has_element?(index_live, "#notes-#{note.id}")
    # end
  end

  describe "Show" do
    setup [:create_note]

    test "displays note", %{conn: conn, note: note} do
      {:ok, _show_live, html} = live(conn, ~p"/notes/#{note}")

      assert html =~ "Show Note"
      assert html =~ note.content
    end

    # test "updates note within modal", %{conn: conn, note: note} do
    #   {:ok, show_live, _html} = live(conn, ~p"/notes/#{note}")

    #   assert show_live |> element("a", "Edit") |> render_click() =~
    #            "Edit Note"

    #   assert_patch(show_live, ~p"/notes/#{note}/show/edit")

    #   assert show_live
    #          |> form("#note-form", note: @invalid_attrs)
    #          |> render_change() =~ "can&#39;t be blank"

    #   assert show_live
    #          |> form("#note-form", note: @update_attrs)
    #          |> render_submit()

    #   assert_patch(show_live, ~p"/notes/#{note}")

    #   html = render(show_live)
    #   assert html =~ "Note updated successfully"
    #   assert html =~ "some updated content"
    # end
  end
end
