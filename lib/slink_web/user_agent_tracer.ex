defmodule SlinkWeb.UserAgentTracer do
  use SlinkWeb, :verified_routes
  require Logger
  import Plug.Conn

  alias Slink.Accounts

  @max_age 60 * 60 * 24 * 365
  @user_agent_cookie "_slink_tracer"
  @user_agent_options [sign: true, max_age: @max_age, same_site: "Lax"]

  def init(opts), do: opts

  def call(conn, _opts) do
    ua = get_req_header(conn, "user-agent") |> List.first()
    do_trace(conn, ua)
  end

  def do_trace(conn, nil), do: conn

  def do_trace(conn, ua) do
    conn = fetch_cookies(conn, signed: [@user_agent_cookie])

    {agent, conn} =
      conn.cookies[@user_agent_cookie]
      |> case do
        nil ->
          nil

        agent_id ->
          Accounts.UserAgent.find_by(id: agent_id)
          |> case do
            # maybe found invalid agent-id
            nil -> nil
            agent -> agent
          end
      end
      |> case do
        nil ->
          agent =
            %{
              agent: ua,
              last_user_id: user_id(conn),
              last_ip: conn.remote_ip |> IpHelper.as_string()
            }
            |> Accounts.UserAgent.create!()

          {agent,
           conn
           |> put_resp_cookie(@user_agent_cookie, agent.id, @user_agent_options)}

        found ->
          {found, conn}
      end

    conn
    |> assign(:current_agent, agent)
  end

  def user_id(%{assigns: %{current_user: u}}) when not is_nil(u), do: u.id
  def user_id(_), do: nil
end
