defmodule SlinkWeb.LinkLive.Index do
  use SlinkWeb, :live_view
  require Logger

  alias Slink.Links
  alias Slink.Links.Link

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :links, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:ok, {links, meta}} = Links.paging_links(params)

    sock =
      socket
      |> assign(:meta, meta)
      |> apply_action(socket.assigns.live_action, params)
      |> stream(:links, links, reset: true)

    {:noreply, sock}
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
    new_sock =
      socket
      |> put_flash(:info, "save link-#{link.id} ok")
      |> push_patch(to: ~p"/links")

    {:noreply, new_sock}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    link = Links.get_link!(id)
    {:ok, _} = Links.delete_link(link)

    new_sock =
      socket
      |> put_flash(:info, "delete link-#{id} ok")
      |> push_patch(to: ~p"/links")

    {:noreply, new_sock}
  end

  def get_links() do
    Links.list_links()
  end
end
