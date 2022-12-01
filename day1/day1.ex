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

  def top_elf(elves) do
    elves
    |> sum_elf
    |> Enum.max()
  end

  def top_three(elves) do
    elves
    |> sum_elf()
    |> Enum.sort(:desc)
    |> Enum.take(3)
  end
end

# part 1
File.read!("./puzzle.input")
|> Calories.parse_input()
|> Calories.top_elf()
|> IO.puts()

# part 2
File.read!("./puzzle.input")
|> Calories.parse_input()
|> Calories.top_three()
|> Enum.sum()
|> IO.inspect()
