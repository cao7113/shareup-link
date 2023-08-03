defmodule Slink.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Slink.Links` context.
  """

  @doc """
  Generate a unique link url.
  """
  def unique_link_url, do: "some url#{System.unique_integer([:positive])}"

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        title: "some title",
        url: unique_link_url()
      })
      |> Slink.Links.create_link()

    link
  end
end
