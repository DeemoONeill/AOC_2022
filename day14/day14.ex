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
        path
        |> Enum.map(&points/1)
        |> List.flatten()
        |> MapSet.new()
        |> MapSet.union(acc)
    end
  end

  def check_below(map, {x, y}) do
    {MapSet.member?(map, {x - 1, y + 1}), MapSet.member?(map, {x, y + 1}),
     MapSet.member?(map, {x + 1, y + 1})}
  end

  def sand(map, {_x, y}, max_depth) when y > max_depth, do: map

  def sand(map, {x, y} = starting_point, max_depth) do
    case {check_below(map, starting_point), starting_point == {500, 0}} do
      {{_, false, _}, _} -> sand(map, {x, y + 1}, max_depth)
      {{false, true, _}, _} -> sand(map, {x - 1, y}, max_depth)
      {{true, true, false}, _} -> sand(map, {x + 1, y}, max_depth)
      {{true, true, true}, false} -> sand(MapSet.put(map, starting_point), {500, 0}, max_depth)
      {{true, true, true}, true} -> MapSet.put(map, starting_point)
    end
  end

  def size(map), do: map |> Enum.count()

  def depth(map), do: map |> Stream.map(&(&1 |> elem(1))) |> Enum.max()

  def width(map), do: map |> Stream.map(&(&1 |> elem(0))) |> Enum.max()

  def cave_floor(map),
    do:
      points([
        {-width(map), depth(map) + 2},
        {width(map) + div(width(map), 2), depth(map) + 2}
      ])
      |> MapSet.new()
      |> MapSet.union(map)

  def simulate(map, pre_length) do
    (sand(map, {500, 0}, depth(map))
     |> Enum.count()) - pre_length
  end

  def part1(input) do
    map =
      input
      |> Paths.get_points()
      |> Paths.create_map()

    pre_length = size(map)

    simulate(map, pre_length)
    |> IO.inspect(label: "part1")

    map
  end

  def part2(map) do
    floor_map = cave_floor(map)

    pre_length = size(floor_map)

    simulate(floor_map, pre_length)
    |> IO.inspect(label: "part2")
  end
end

"puzzle.input"
|> File.read!()
|> String.split("\n")
|> Paths.part1()
|> Paths.part2()
