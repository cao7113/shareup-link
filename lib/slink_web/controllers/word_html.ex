defmodule SlinkWeb.WordHTML do
  use SlinkWeb, :html

  embed_templates "word_html/*"

  @doc """
  Renders a word form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def word_form(assigns)
end
