defmodule Slink.Links do
  @moduledoc """
  The Links context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias Slink.Repo
  alias Slink.Links.Link

  @permit_link_keys [:title, :url]

  @doc """
  submit batch links params from user
  """
  def batch_submit(links_params) when is_list(links_params) do
    links_params
    |> Enum.map(fn it ->
      it
      |> MapHelper.cast_plain_params(@permit_link_keys)
      |> Map.update!(:url, fn url ->
        len = String.length(url)

        if len > 400 do
          Logger.warn("url too long. (#{len} > 400) url: #{url}")
          String.slice(url, 0..399)
        else
          url
        end
      end)
      |> Map.update!(:title, fn title ->
        len = String.length(title)

        if len > 200 do
          Logger.warn("url too long. (#{len} > 200) url: #{title}")
          String.slice(title, 0..199)
        else
          title
        end
      end)
    end)
    |> RepoHelper.batch_import(Repo, Link,
      on_conflict: :nothing,
      conflict_target: [:url]
    )
  end

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id), do: Repo.get!(Link, id)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end
end
