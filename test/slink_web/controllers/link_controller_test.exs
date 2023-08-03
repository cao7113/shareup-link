defmodule SlinkWeb.LinkControllerTest do
  use SlinkWeb.ConnCase

  import Slink.LinksFixtures
  alias Slink.Links.Link

  @create_attrs %{
    title: "some title",
    url: "some url"
  }
  @update_attrs %{
    title: "some updated title",
    url: "some updated url"
  }
  @invalid_attrs %{title: nil, url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all links", %{conn: conn} do
      conn = get(conn, ~p"/api/links")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create link" do
    test "renders link when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/links", link: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/links/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some title",
               "url" => "some url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/links", link: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update link" do
    setup [:create_link]

    test "renders link when data is valid", %{conn: conn, link: %Link{id: id} = link} do
      conn = put(conn, ~p"/api/links/#{link}", link: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/links/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some updated title",
               "url" => "some updated url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, link: link} do
      conn = put(conn, ~p"/api/links/#{link}", link: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete link" do
    setup [:create_link]

    test "deletes chosen link", %{conn: conn, link: link} do
      conn = delete(conn, ~p"/api/links/#{link}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/links/#{link}")
      end
    end
  end

  defp create_link(_) do
    link = link_fixture()
    %{link: link}
  end
end
