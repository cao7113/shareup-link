defmodule SlinkWeb.LinkJSON do
  alias Slink.Links.Link

  @doc """
  Renders a list of links.
  """
  def index(%{links: links, meta: meta}) do
    %{
      data: for(link <- links, do: data(link)),
      meta: meta
    }
  end

  @doc """
  Renders a single link.
  """
  def show(%{link: link}) do
    %{data: data(link)}
  end

  defp data(%Link{} = link) do
    %{
      id: link.id,
      title: link.title,
      url: link.url,
      inserted_at: link.inserted_at,
      updated_at: link.updated_at
    }
  end
end
