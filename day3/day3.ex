defmodule Rucksack do
  @moduledoc """
  Calculates the priority of items in elf rucksacks
  """

  @doc """
  Calculate priority in a split line
  """
  def part1(lines) do
    lines
    |> calculate_line_priority()
    |> Enum.sum()
  end

  @doc """
  Calculate priority between 3 elves items
  """
  def part2(lines) do
    lines
    |> convert_line_to_set()
    |> Enum.chunk_every(3, 3)
    |> Enum.map(&find_intersection/1)
    |> Enum.map(&calculate_priority/1)
    |> Enum.sum()
  end

  def parse_input(filename) do
    File.stream!(filename)
  end

  @doc """
  given a generator of lines, returns the priority of the intersection of each line
  """
  defp calculate_line_priority(lines) do
    for line <- lines do
      line
      |> to_charlist()
      |> split_line_in_half()
      |> find_intersection()
      |> calculate_priority()
    end
  end

  defp convert_line_to_set(lines) do
    for line <- lines do
      MapSet.new(
        line
        |> to_charlist()
      )
    end
  end

  defp to_charlist(line) do
    line
    |> String.trim()
    |> String.to_charlist()
  end

  defp split_line_in_half(line) do
    line
    |> Enum.split(floor(length(line) / 2))
    |> Tuple.to_list()
    |> Enum.map(&MapSet.new/1)
  end

  @doc """
  Takes a mapset of the values in the intersection and converts it to an int
  representing the priority
  """
  defp calculate_priority(mapset) do
    # charlists are integers a = [97], A = [65]
    # uppercase letters - 38 to get priority
    # lowercase letters - 96 to get priority
    [num] =
      mapset
      |> MapSet.to_list()

    if num >= 96 do
      num - 96
    else
      num - 38
    end
  end

  @doc """
  Finds the intersection between 2 or 3 mapsets
    This could be generalised to any list list of mapsets
  """
  defp find_intersection([mapset1, mapset2]) do
    MapSet.intersection(mapset1, mapset2)
  end

  defp find_intersection([mapset1, mapset2, mapset3]) do
    MapSet.intersection(mapset1, mapset2)
    |> MapSet.intersection(mapset3)
  end
end

"./puzzle.input"
|> Rucksack.parse_input()
|> Rucksack.part1()
|> IO.inspect()

"./puzzle.input"
|> Rucksack.parse_input()
|> Rucksack.part2()
|> IO.inspect()
