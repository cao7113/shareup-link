defmodule Slink.Links do
  @moduledoc """
  The Links context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias Slink.Repo
  alias Slink.Links.Link

  def list_links(opts \\ []) do
    limit = opts[:limit] || 10

    Link
    |> order_by(desc: :id)
    |> limit(^limit)
    |> Repo.all()
  end

  def paging_links(params \\ %{}) when is_map(params) do
    Flop.validate_and_run(Link, params, for: Link)
  end

  def paging_links2(opts \\ []) when is_list(opts) do
    opts
    |> Map.new()
    |> paging_links()
  end

  def query_from_ids(ids) when is_list(ids),
    do: from(l in Link, where: l.id in ^ids)

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
  Submit batch links params from user
  """
  def create_links(links_params) when is_list(links_params) do
    links_params
    |> Enum.reduce_while([], fn params, acc ->
      Link.changeset(%Link{}, params)
      |> case do
        %{valid?: true, changes: changes} ->
          {:cont, [changes | acc]}

        %{errors: errors} = cs ->
          Logger.warn("cast failed: #{errors |> inspect} for link params: #{params |> inspect}")
          {:halt, {:error, cs}}
      end
    end)
    |> case do
      {:error, _} = err ->
        err

      items ->
        {cnt, _} =
          items
          |> Enum.reverse()
          |> RepoHelper.batch_import(Repo, Link,
            on_conflict: :nothing,
            conflict_target: [:url]
          )

        {:ok, cnt}
    end
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
