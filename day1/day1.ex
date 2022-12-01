defmodule Calories do
  def parse_input(input) do
    input
    |> split_elves
    |> convert_to_int()
  end

  defp split_elves(input) do
    input
    |> String.split("\n\n")
  end

  defp convert_to_int(calories) do
    calories
    |> Enum.map(
      &(String.split(&1, "\n")
        |> Enum.map(fn num -> String.to_integer(num) end))
    )
  end

  defp sum_elf(elf) do
    elf
    |> Enum.map(&Enum.sum/1)
  end

  def top_elves(elves, n \\ 1) do
    elves
    |> sum_elf
    |> Enum.sort(:desc)
    |> Enum.take(n)
  end
end

# part 1
File.read!("./puzzle.input")
|> Calories.parse_input()
|> Calories.top_elves()
|> Enum.sum()
|> IO.inspect()

# part 2
File.read!("./puzzle.input")
|> Calories.parse_input()
|> Calories.top_elves(3)
|> Enum.sum()
|> IO.inspect()
