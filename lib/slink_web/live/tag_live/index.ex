defmodule SlinkWeb.TagLive.Index do
  use SlinkWeb, :live_view

  alias Slink.Tags
  alias Slink.Tags.Tag

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tags, Tags.list_tags())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tag")
    |> assign(:tag, Tags.get_tag!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tag")
    |> assign(:tag, %Tag{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tags")
    |> assign(:tag, nil)
  end

  @impl true
  def handle_info({SlinkWeb.TagLive.FormComponent, {:saved, tag}}, socket) do
    {:noreply, stream_insert(socket, :tags, tag)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tag = Tags.get_tag!(id)
    {:ok, _} = Tags.delete_tag(tag)

    {:noreply, stream_delete(socket, :tags, tag)}
  end

  def handle_event("touch_auto_match", %{"id" => id}, socket) do
    tag = Tags.get_tag!(id)
    {:ok, tag} = Tags.update_tag(tag, %{auto_match_touch_at: Timex.now()})

    {:noreply, stream_insert(socket, :tags, tag)}
  end

  def handle_event("touch_pin_top", %{"id" => id}, socket) do
    tag = Tags.get_tag!(id)
    {:ok, tag} = Tags.update_tag(tag, %{pin_top_touch_at: Timex.now()})

    {:noreply, stream_insert(socket, :tags, tag)}
  end
end
