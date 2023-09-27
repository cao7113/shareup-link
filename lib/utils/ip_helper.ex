defmodule IpHelper do
  def as_string(str) when is_binary(str), do: str
  def as_string({a, b, c, d}), do: [a, b, c, d] |> Enum.map(&to_string/1) |> Enum.join(".")
end
