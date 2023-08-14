defmodule Slink.WordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Slink.Words` context.
  """

  @doc """
  Generate a word.
  """
  def word_fixture(attrs \\ %{}) do
    {:ok, word} =
      attrs
      |> Enum.into(%{
        note: "some note",
        word: "some word"
      })
      |> Slink.Words.create_word()

    word
  end
end
