defmodule SlinkWeb.WordControllerTest do
  use SlinkWeb.ConnCase

  import Slink.WordsFixtures

  @create_attrs %{note: "some note", word: "some word"}
  @update_attrs %{note: "some updated note", word: "some updated word"}
  @invalid_attrs %{note: nil, word: nil}

  describe "index" do
    test "lists all words", %{conn: conn} do
      conn = get(conn, ~p"/words")
      assert html_response(conn, 200) =~ "Listing Words"
    end
  end

  describe "new word" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/words/new")
      assert html_response(conn, 200) =~ "New Word"
    end
  end

  describe "create word" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/words", word: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/words/#{id}"

      conn = get(conn, ~p"/words/#{id}")
      assert html_response(conn, 200) =~ "Word #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/words", word: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Word"
    end
  end

  describe "edit word" do
    setup [:create_word]

    test "renders form for editing chosen word", %{conn: conn, word: word} do
      conn = get(conn, ~p"/words/#{word}/edit")
      assert html_response(conn, 200) =~ "Edit Word"
    end
  end

  describe "update word" do
    setup [:create_word]

    test "redirects when data is valid", %{conn: conn, word: word} do
      conn = put(conn, ~p"/words/#{word}", word: @update_attrs)
      assert redirected_to(conn) == ~p"/words/#{word}"

      conn = get(conn, ~p"/words/#{word}")
      assert html_response(conn, 200) =~ "some updated note"
    end

    test "renders errors when data is invalid", %{conn: conn, word: word} do
      conn = put(conn, ~p"/words/#{word}", word: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Word"
    end
  end

  describe "delete word" do
    setup [:create_word]

    test "deletes chosen word", %{conn: conn, word: word} do
      conn = delete(conn, ~p"/words/#{word}")
      assert redirected_to(conn) == ~p"/words"

      assert_error_sent 404, fn ->
        get(conn, ~p"/words/#{word}")
      end
    end
  end

  defp create_word(_) do
    word = word_fixture()
    %{word: word}
  end
end
