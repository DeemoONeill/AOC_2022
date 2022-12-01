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
    # equivalent to [map(int, calorie) for calorie in map(str.split, calories)]
    for calorie <- Stream.map(calories, &String.split/1) do
      Stream.map(calorie, &String.to_integer/1)
    end
  end

  defp sum_elf(elf) do
    elf
    |> Stream.map(&Enum.sum/1)
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

# using one "anonymous" function
pipeline = fn n ->
  File.read!("./puzzle.input")
  |> String.split("\n\n")
  |> Enum.map(
    &(for num <- String.split(&1) do
        String.to_integer(num)
      end
      |> Enum.sum())
  )
  |> Enum.sort(:desc)
  |> Enum.take(n)
  |> Enum.sum()
  |> IO.inspect()
end

pipeline.(1)
pipeline.(3)
