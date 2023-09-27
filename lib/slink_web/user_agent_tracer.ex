defmodule SlinkWeb.UserAgentTracer do
  use SlinkWeb, :verified_routes
  require Logger

  import Plug.Conn
  # import Phoenix.Controller

  alias Slink.Accounts

  @max_age 60 * 60 * 24 * 365
  @user_agent_cookie "_slink_tracer"
  @user_agent_options [sign: true, max_age: @max_age, same_site: "Lax"]

  def trace_agent(conn, _opts) do
    ua = get_req_header(conn, "user-agent") |> List.first()
    do_trace(conn, ua)
  end

  def do_trace(conn, nil), do: conn

  def do_trace(conn, ua) do
    conn = fetch_cookies(conn, signed: [@user_agent_cookie])

    {agent, conn} =
      if agent_id = conn.cookies[@user_agent_cookie] do
        agent = Accounts.UserAgent.find(agent_id)
        {agent, conn}
      else
        agent =
          %{
            agent: ua,
            last_ip: conn.remote_ip |> IpHelper.as_string()
          }
          |> Accounts.UserAgent.create!()

        {agent,
         conn
         |> put_resp_cookie(@user_agent_cookie, agent.id, @user_agent_options)}
      end

    conn
    |> assign(:current_agent, agent)
  end
end
