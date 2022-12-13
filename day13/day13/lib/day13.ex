defmodule Packets do
  def compare([list1, list2]) do
    compare(list1, list2)
  end

  def compare([], [_list2 | _l2]), do: true
  def compare([_list1 | _l1], []), do: false
  def compare([], []), do: nil

  def compare([l1_head | l1tail], [l2_head | l2tail])
      when is_integer(l1_head) and is_integer(l2_head) do
    case {l1_head < l2_head, l1_head > l2_head} do
      {true, _} -> true
      {false, false} -> compare(l1tail, l2tail)
      {_, true} -> false
    end
  end

  def compare([l1_head | l1tail], [l2_head | l2tail])
      when is_integer(l1_head) and is_list(l2_head) do
    compare([[l1_head] | l1tail], [l2_head | l2tail])
  end

  def compare([l1_head | l1tail], [l2_head | l2tail])
      when is_list(l1_head) and is_integer(l2_head) do
    compare([l1_head | l1tail], [[l2_head] | l2tail])
  end

  def compare([l1_head | l1tail], [l2_head | l2tail])
      when is_list(l1_head) and is_list(l2_head) do
    case compare(l1_head, l2_head) do
      true -> true
      false -> false
      nil -> compare(l1tail, l2tail)
    end
  end
end

input =
  "puzzle.input"
  |> File.read!()
  |> String.split()
  |> Enum.map(&(JSON.decode(&1) |> elem(1)))

input
|> Enum.chunk_every(2)
|> Enum.with_index(1)
|> Enum.map(fn {lists, index} ->
  if Packets.compare(lists) do
    index
  else
    0
  end
end)
|> Enum.sum()
|> IO.inspect()

[[[6]] | [[[2]] | input]]
|> Enum.sort(&Packets.compare/2)
|> Enum.with_index(1)
|> Enum.filter(fn {num, _index} -> num == [[2]] or num == [[6]] end)
|> Enum.map(&elem(&1, 1))
|> Enum.product()
|> IO.inspect()
