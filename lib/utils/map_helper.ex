defmodule MapHelper do
  def atomize_plain_map(params) do
    params
    |> Enum.into(%{}, fn
      {k, v} when is_atom(k) ->
        {k, v}

      {k, v} ->
        {String.to_atom(k), v}
    end)
  end

  def cast_plain_params(params, permit_fields) when is_list(permit_fields) do
    fields =
      permit_fields
      |> Enum.map(&to_string/1)
      |> Enum.uniq()

    params
    |> Map.take(fields)
    |> atomize_plain_map()
  end
end
