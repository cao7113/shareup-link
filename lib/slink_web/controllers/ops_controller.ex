defmodule SlinkWeb.OpsController do
  use SlinkWeb, :controller
  action_fallback SlinkWeb.FallbackController

  def ping(conn, _params) do
    json(conn, %{
      status: :ok,
      message: "pong at #{DateTime.utc_now()}"
    })
  end
end
