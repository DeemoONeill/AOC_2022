defmodule Paths do


  def points([{x1, y1}, {x2, y2}]) when x1 == x2 do
    for y <- y1..y2 do
      {x1, y}
    end
  end

  def points([{x1, y1}, {x2, y2}]) when y1 == y2 do
    for x <- x1..x2 do
      {x, y1}
    end
  end

  def get_points(input) do
    input
    |> Enum.map(
      &(String.trim(&1)
        |> String.split(" -> ")
        |> Enum.map(fn string ->
          [x, y] = string |> String.split(",")
          {x |> String.to_integer(), y |> String.to_integer()}
        end))
    )
    |> Enum.map(&Enum.chunk_every(&1, 2, 1, :discard))
  end

  def create_map(paths) do
    for path <- paths, reduce: MapSet.new() do
      acc ->
        for point <- path do
          Paths.points(point)
        end
        |> List.flatten()
        |> MapSet.new()
        |> MapSet.union(acc)
    end
  end
  def check_below(map, {x, y}) do
    {MapSet.member?(map, {x - 1, y + 1}), MapSet.member?(map, {x, y + 1}), MapSet.member?(map, {x + 1, y + 1})}
  end

  def sand(map, {_x, y}, max_depth) when y > max_depth, do: map
  def sand(map, {x, y} = starting_point, max_depth) do
    case {check_below(map, starting_point), starting_point == {500 , 0}} do
      {{_, false, _}, _} -> sand(map, {x, y + 1}, max_depth)
      {{true, true, true}, false} -> sand(MapSet.put(map, starting_point), {500, 0}, max_depth)
      {{true, true, true}, true} -> MapSet.put(map, starting_point)
      {{false, true, _}, _} -> sand(map, {x - 1, y}, max_depth)
      {{true, true, false}, _} -> sand(map, {x + 1, y}, max_depth)

    end
  end
end

map =
"puzzle.input"
|> File.read!()
  |> String.split("\n")
  |> Paths.get_points()
  |> Paths.create_map()

pre_length = map |> MapSet.to_list() |> length()
max_depth = map |> MapSet.to_list() |> Enum.map(&(&1 |> elem(1))) |> Enum.max

sand = map
|> Paths.sand({500, 0}, max_depth)
|> MapSet.to_list()
|> length()

(sand - pre_length) |> IO.inspect(label: "Part 1")


floor_depth = max_depth + 2

maxx = map |> MapSet.to_list() |> Enum.map(&(&1 |> elem(1))) |> Enum.max()
factor = maxx * maxx
map = Paths.points([{-factor, floor_depth}, {factor, floor_depth}])
|> MapSet.new()
|> MapSet.union(map)

pre_length = map |> MapSet.to_list() |> length()

sand = map
|> Paths.sand({500, 0}, max_depth + 2)
|> MapSet.to_list()
|> length()

(sand - pre_length) |> IO.inspect(label: "Part 2")
