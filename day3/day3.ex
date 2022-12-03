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

  defp calculate_line_priority(lines) do
    # given a generator of lines, returns the priority of the intersection of each line
    for line <- lines do
      line
      |>strip_to_charlist()
      |> split_line_in_half()
      |> find_intersection()
      |> calculate_priority()
    end
  end

  defp convert_line_to_set(lines) do
    for line <- lines do
      MapSet.new(
        line
        |>strip_to_charlist()
      )
    end
  end

  defp strip_to_charlist(line) do
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


  defp find_intersection([first, second | tail]) do
    #  Finds the intersection between mapsets
    find_intersection(tail, MapSet.intersection(first, second))
  end

  defp find_intersection([], acc), do: acc
  defp find_intersection([head|tail], acc) do
    find_intersection(tail, MapSet.intersection(head, acc))
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
