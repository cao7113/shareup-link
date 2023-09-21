defmodule Slink.Links.LinkAdmin do
  def index(_) do
    [
      id: nil,
      title: %{
        name: "Title",
        value: fn it ->
          it.title |> String.slice(0..25)
        end
      },
      url: %{
        name: "URL",
        value: fn it ->
          it.url |> String.slice(0..40)
        end
      },
      inserted_at: nil,
      updated_at: nil
    ]
  end

  def list_actions(_conn) do
    [
      delete_all: %{
        name: "Delete All",
        action: fn _conn, items ->
          items
          |> Enum.map(& &1.id)
          |> Slink.Links.query_from_ids()
          |> Slink.Repo.delete_all()

          :ok
        end
      }
    ]
  end
end
