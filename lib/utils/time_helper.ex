defmodule TimeHelper do
  def naive_now() do
    # Timex.now()
    # |> Timex.to_naive_datetime()
    # |> NaiveDateTime.truncate(:second)

    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end
end
