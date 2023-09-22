defmodule Slink.Sites do
  import Ecto.Query
  alias Slink.Links
  alias Slink.Repo
  alias Slink.Sites

  def load_from_links! do
    Links.Link
    |> where([l], is_nil(l.site_id))
    |> Repo.all()
    # todo
    |> Enum.each(fn it ->
      {shost, domain} = base_from(it.url)

      with {:ok, site} <-
             Sites.Site.find_or_create_by(%{
               host: shost,
               domain: domain
             }),
           {:ok, up_link} <- Links.Link.update(it, %{site_id: site.id}) do
        up_link
      else
        err -> raise "parse link #{it |> inspect} #{err |> inspect}"
      end
    end)
  end

  def base_from("http" <> _ = url) do
    # "https://docs.base.org/tools/network-faucets/"
    %URI{
      scheme: scheme,
      # authority: "docs.base.org",
      userinfo: nil,
      host: host,
      port: port
      # path: "/tools/network-faucets/",
      # query: nil,
      # fragment: nil
    } = URI.parse(url)

    shost = get_base(scheme, host, port)

    domain =
      host
      |> String.split(".")
      |> get_domain()
      |> Enum.join(".")

    domain_p = domain_with_port(domain, port)
    {shost, domain_p}
  end

  def get_base("https", host, 443), do: "https://#{host}"
  def get_base("http", host, 80), do: "http://#{host}"
  def get_base(s, host, port), do: "#{s}://#{host}:#{port}"

  def get_domain([_, _] = parts), do: parts
  def get_domain([_ | tail]), do: get_domain(tail)
  def get_domain(parts), do: parts

  def domain_with_port(domain, p) when p in [80, 443], do: domain
  def domain_with_port(domain, p), do: "#{domain}:#{p}"
end
