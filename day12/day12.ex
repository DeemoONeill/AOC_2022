

example = "Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi"

defmodule Height do
  def find_starting(grid) do
    Map.to_list(grid) |> Enum.filter(&(&1 |> elem(1) == 96)) |> hd |> elem(0)
  end

  def search(start, grid) do
    search(start, Map.get(grid, start), MapSet.new(), grid)
  end
  def search(_current, 123, visited, _grid), do: visited
  def search({y, x} = current,letter, visited,grid) do
    north = {y + 1, x}
    east = {y, x + 1}
    south = {y - 1, x}
    west = {y, x - 1}

    for direction <- [north, east, south, west] do

      case Map.get(grid, direction) do
        nil -> nil
        number when abs(number - letter) <= 1 ->
          if not MapSet.member?(visited, direction) do
            search(direction, number, MapSet.put(visited, current), grid)
          else
            nil
          end
        _ -> nil
      end
    end
    |> List.flatten()
    |> Enum.filter(& &1)

  end

  def parse_grid(lines) do
    for {line, row} <- lines |> Enum.with_index(), reduce: %{} do
  acc -> for {item, column} <- line |> String.trim |> String.to_charlist |> Enum.with_index(), reduce: acc do
    inner -> item = case item do
      83 -> 96
      69 -> 123
      num -> num
    end
    Map.put(inner, {row, column}, item)
  end
end
  end
end


_example_grid = example |> String.split() |> Height.parse_grid()
grid = "puzzle.input" |> File.stream!() |> Height.parse_grid()

Height.find_starting(grid)
|> Height.search(grid)
|> Enum.map(&MapSet.to_list(&1) |> length)
|> Enum.min()
|> IO.inspect()
