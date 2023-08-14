defmodule SlinkWeb.OpsControllerTest do
  use SlinkWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "ping" do
    test "ok", %{conn: conn} do
      conn = get(conn, ~p"/api")
      # %{"message" => "pong at 2023-08-11 02:57:52.494677Z", "status" => "ok"}
      resp = json_response(conn, 200)
      assert resp["status"] == "ok"
      "pong" <> _ = resp["message"]

      # on api root
      conn = get(conn, ~p"/api")
      assert json_response(conn, 200)["status"] == "ok"
    end
  end
end
