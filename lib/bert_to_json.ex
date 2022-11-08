defmodule BertToJson do
  @moduledoc """
  Documentation for `BertToJson`.
  """
  use Bakeware.Script

  def list2map(:voidmap), do: %{}
  def list2map([{_, _} | _] = l), do: l |> Enum.map(&list2map/1) |> Enum.into(%{})
  def list2map(l) when is_list(l), do: Enum.map(l, &list2map/1)

  def list2map(t) when is_tuple(t),
    do: t |> Tuple.to_list() |> Enum.map(&list2map/1) |> List.to_tuple()

  def list2map(term), do: term

  def map2list(m) when is_map(m) and map_size(m) == 0, do: :voidmap
  def map2list(m) when is_map(m), do: m |> Map.to_list() |> Enum.map(&map2list/1)
  def map2list(l) when is_list(l), do: Enum.map(l, &map2list/1)

  def map2list(t) when is_tuple(t),
    do: t |> Tuple.to_list() |> Enum.map(&map2list/1) |> List.to_tuple()

  def map2list(term), do: term

  def decode(v), do: v |> :erlang.binary_to_term() |> list2map

  @impl Bakeware.Script
  def main(args) do
    parsed =
      args
      |> OptionParser.parse(strict: [])

    with {_options, [file], []} <- parsed,
         true <- File.exists?(file),
         bert_data <- File.read!(file) do
      decoded_file = decode(bert_data)
      File.write!("out.json", Jason.encode!(decoded_file))
    else
      _ ->
        IO.puts("Invalid input")
        System.halt(1)
    end
  end
end
