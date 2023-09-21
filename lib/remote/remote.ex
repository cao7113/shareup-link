defmodule Remote do
  @moduledoc """
  Remote resource request client
  """

  def fetch_links(params \\ %{}, opts \\ []) do
    url = opts[:url] || get_links_url(opts[:remote])

    with {:ok, resp} <- Req.get(url: url, params: params) do
      resp.body["data"]
      |> Enum.map(fn it -> Map.take(it, ["title", "url"]) end)
      |> Slink.Links.create_links()
    end
  end

  def get_links_url(nil), do: get_links_url(:fly)

  def get_links_url(:fly) do
    "https://slink.fly.dev/api/links"
  end

  def get_links_url(:local) do
    "http://localhost:4000/api/links"
  end
end
