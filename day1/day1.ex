defmodule Calories do
  def calculate(filename, n_elves \\ 1) do
    File.read!(filename)
    |> parse_input()
    |> top_elves(n_elves)
    |> Enum.sum()
    |> IO.inspect()
  end

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
Calories.calculate("./puzzle.input")

# part 2
Calories.calculate("./puzzle.input", 3)

defmodule Recursive_elves do
  def calculate(filename, n \\ 1) do
    parse_input(filename)
    |> top_elves(n)
    |> Enum.sum()
  end

  def parse_input(filename) do
    file = File.open!(filename)
    sum_elves(IO.read(file, :line), file, 0, [])
  end

  defp sum_elves(:eof, _file, current, acc), do: [current | acc]

  defp sum_elves(line, file, current, acc) do
    case Integer.parse(line) do
      {num, _} -> sum_elves(IO.read(file, :line), file, current + num, acc)
      :error -> sum_elves(IO.read(file, :line), file, 0, [current | acc])
    end
  end

  def top_elves(elves, n \\ 1) do
    elves
    |> Enum.sort(:desc)
    |> Enum.take(n)
  end
end

# part 1
Recursive_elves.calculate("./puzzle.input")
|> IO.puts()

# part 2
Recursive_elves.calculate("./puzzle.input", 3)
|> IO.puts()
