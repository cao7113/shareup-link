defmodule IpHelper do
  def as_string(str) when is_binary(str), do: str

  # iex> IpHelper.as_string({0, 0, 0, 0, 0, 65535, 44048, 33698})
  def as_string(parts) when is_tuple(parts),
    do: parts |> Tuple.to_list() |> Enum.map(&to_string/1) |> Enum.join(".")
end
