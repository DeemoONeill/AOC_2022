input_crates = %{
  1 => ["V", "N", "F", "S", "M", "P", "H", "J"],
  2 => ["Q", "D", "J", "M", "L", "R", "S"],
  3 => ["B", "W", "S", "C", "H", "D", "Q", "N"],
  4 => ["L", "C", "S", "R"],
  5 => ["B", "F", "P", "T", "V", "M"],
  6 => ["C", "N", "Q", "R", "T"],
  7 => ["R", "V", "G"],
  8 => ["R", "L", "D", "P", "S", "Z", "C"],
  9 => ["F", "B", "P", "G", "V", "J", "S", "D"]
}

sample_input = %{
  1 => ["N", "Z"],
  2 => ["D", "C", "M"],
  3 => ["P"]
}

sample_instructions = "
  move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2"

defmodule Crates do
  @doc """
  returns a list of instructions which are lists of [quantity, from, to]
  """
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

  def apply_instructions(instructions, crates) do
    for instruction <- instructions, reduce: crates do
      acc -> instruction |> move_crates(acc)
    end
  end

  def move_crates([], crates), do: crates
  def move_crates([0, _from, _to], crates), do: crates

  def move_crates([quantity, from, to], crates) do
    [from_item | tail] = crates[from]

    to_list = [from_item | crates[to]]

    [-1 + quantity, from, to]
    |> move_crates(%{crates | from => tail, to => to_list})
  end

  def top_crate(crates) do
    for key <- Map.keys(crates) do
      [head | _tail] = crates[key]
      head
    end
  end
end

"puzzle.input"
|> File.stream!()
|> Enum.map(&Crates.parse_instructions/1)
|> Crates.apply_instructions(input_crates)
|> Crates.top_crate()
|> Enum.join()
|> IO.inspect()
