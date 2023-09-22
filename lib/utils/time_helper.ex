defmodule TimeHelper do
  def naive_now() do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end
end
