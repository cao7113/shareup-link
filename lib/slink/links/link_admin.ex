defmodule Slink.Links.LinkAdmin do
  def index(_) do
    [
      id: nil,
      title: %{
        name: "Title",
        value: fn it ->
          it.title |> String.slice(0..20)
        end
      },
      title: %{
        name: "URL",
        value: fn it ->
          it.url |> String.slice(0..20)
        end
      },
      inserted_at: nil,
      updated_at: nil
    ]
  end
end
