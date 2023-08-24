defmodule SlinkWeb.LinkLive.Index do
  use SlinkWeb, :live_view
  require Logger

  alias Slink.Links
  alias Slink.Links.Link

  @impl true
  def mount(params, session, socket) do
    Logger.info(
      "links-index mount with pid: #{self() |> inspect} session: #{session |> inspect} socket: #{socket |> inspect} params: #{params |> inspect}"
    )

    {:ok, stream(socket, :links, Links.list_links())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Link")
    |> assign(:link, Links.get_link!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Link")
    |> assign(:link, %Link{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Links")
    |> assign(:link, nil)
  end

  @impl true
  def handle_info({SlinkWeb.LinkLive.FormComponent, {:saved, link}}, socket) do
    {:noreply, stream_insert(socket, :links, link)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    link = Links.get_link!(id)
    {:ok, _} = Links.delete_link(link)

    {:noreply, stream_delete(socket, :links, link)}
  end
end
