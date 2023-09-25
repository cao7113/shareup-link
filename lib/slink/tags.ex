defmodule Slink.Tags do
  @moduledoc """
  The Tags context.
  """

  import Ecto.Query, warn: false
  alias Slink.Repo
  alias Slink.Tags.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  def auto_match_tags(str, opts \\ []) when is_binary(str) do
    auto_match_regex(opts)
    |> case do
      nil ->
        []

      re ->
        raw_names =
          Regex.scan(re, str, capture: :all_but_first)
          |> List.flatten()
          |> Enum.uniq()

        Tag.where(name: raw_names)
        |> Enum.map(& &1.name)
    end
  end

  def auto_match_regex(opts \\ []) do
    # TODO: use cache
    get_tags_to_auto_match(opts)
    |> case do
      [] ->
        nil

      tags ->
        words =
          tags
          |> Enum.map(& &1.name)
          |> Enum.join("|")

        Regex.compile!("(#{words})", "i")
    end
  end

  def get_tags_to_auto_match(opts \\ []) do
    limit = opts[:limit] || 20

    Tag
    |> where([t], not is_nil(t.auto_match_touch_at))
    |> order_by([t], desc: t.auto_match_touch_at)
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
