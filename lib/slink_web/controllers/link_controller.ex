defmodule SlinkWeb.LinkController do
  use SlinkWeb, :controller
  require Logger
  alias Slink.Links
  alias Slink.Links.Link

  action_fallback SlinkWeb.FallbackController

  def test_to_live(conn, _params) do
    Logger.info("session in plain controller: #{conn |> get_session() |> inspect}")
    redirect(conn, to: ~p"/users/settings")
  end

  def index(conn, _params) do
    links = Links.list_links()
    render(conn, :index, links: links)
  end

  def create(conn, %{"link" => link_params}) do
    Logger.info("creating link: #{link_params |> inspect}")

    with {:ok, %Link{} = link} <- Links.create_link(link_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/links/#{link}")
      |> render(:show, link: link)
    end
  end

  def create(conn, %{"links" => links_params}) when is_list(links_params) do
    submit_cnt = length(links_params)

    Logger.info(
      "handling #{submit_cnt} links: #{links_params |> inspect(printable_limit: 100)} in batch"
    )

    {real_import_cnt, _} = Links.create_links(links_params)

    if real_import_cnt != submit_cnt do
      Logger.warn("final import #{real_import_cnt} vs #{submit_cnt}(attempt) links")
    end

    json(conn, %{
      status: :ok,
      data: %{
        submit_count: submit_cnt,
        import_count: real_import_cnt,
        diff: submit_cnt - real_import_cnt
      }
    })
  end

  def show(conn, %{"id" => id}) do
    link = Links.get_link!(id)
    render(conn, :show, link: link)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = Links.get_link!(id)

    with {:ok, %Link{} = link} <- Links.update_link(link, link_params) do
      render(conn, :show, link: link)
    end
  end

  def delete(conn, %{"id" => id}) do
    link = Links.get_link!(id)

    with {:ok, %Link{}} <- Links.delete_link(link) do
      send_resp(conn, :no_content, "")
    end
  end
end
