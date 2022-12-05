defmodule Crates do
  def parse_crates(input_stream) do
    input_stream
    |> Enum.filter(&String.starts_with?(&1, "["))
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn strings ->
      ["[" | tail] = strings
      Enum.take_every(tail, 4)
    end)
    |> Enum.reverse()
    |> to_map()
  end

  defp to_map(crates) do
    for row <- crates, reduce: Map.new() do
      acc -> row |> push_rows(acc)
    end
  end

  defp push_rows(row, acc) do
    for {crate, index} <- row |> Enum.with_index(1), reduce: acc do
      acc -> update_map(acc, index, crate)
    end
  end

  defp update_map(map, index, crate) do
    case map |> Map.get(index, nil) do
      nil ->
        Map.put(map, index, [crate])

      list ->
        if crate != " ", do: %{map | index => [crate | list]}, else: map
    end
  end

  def parse_instructions(instruction_string) do
    ~r"move (\d+) from (\d) to (\d)"
    |> Regex.scan(instruction_string)
    |> List.flatten()
    |> Enum.map(fn num ->
      case Integer.parse(num) do
        {int, ""} -> int
        :error -> :error
      end
    end)
    |> Enum.filter(&is_integer/1)
  end

  def apply_instructions(instructions, crates, crate_mover) do
    for instruction <- instructions, reduce: crates do
      acc -> instruction |> crate_mover.(acc)
    end
  end

  def crate_mover9000([], crates), do: crates
  def crate_mover9000([0, _from, _to], crates), do: crates

  def crate_mover9000([quantity, from, to], crates) do
    tail = crates[from] |> tl

    to_list = [crates[from] |> hd | crates[to]]

    [quantity - 1, from, to]
    |> crate_mover9000(%{crates | from => tail, to => to_list})
  end

  def crate_mover9001([], crates), do: crates

  def crate_mover9001([quantity, from, to], crates) do
    {from_list, tail} =
      crates[from]
      |> Enum.split(quantity)

    to_list = from_list ++ crates[to]

    %{crates | from => tail, to => to_list}
  end

  def top_crates(crates) do
    for key <- Map.keys(crates) |> Enum.sort() do
      crates[key]
      |> hd
    end
  end

  def solve(puzzle_input, moving_func) do
    puzzle_input
    |> Enum.map(&parse_instructions/1)
    |> apply_instructions(puzzle_input |> parse_crates, moving_func)
    |> top_crates()
    |> Enum.join()
  end
end

puzzle_input =
  "puzzle.input"
  |> File.read!()
  |> String.split("\n")

puzzle_input
|> Crates.solve(&Crates.crate_mover9000/2)
|> IO.puts()

puzzle_input
|> Crates.solve(&Crates.crate_mover9001/2)
|> IO.puts()
