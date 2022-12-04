defmodule Assignments do
  def split_into_assignments(row) do
    row
    |> String.split(",")
    |> Enum.map(&Assignments.parse_assignment/1)
  end

  def part(inputs, func) do
    for row <- inputs do
      split_into_assignments(row) |> func.()
    end
    |> Enum.count(& &1)
  end

  def parse_assignment(string) do
    string
    |> String.trim()
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  def contains?([[start1, end1], [start2, end2]]) do
    (start1 >= start2 and end1 <= end2) or (start1 <= start2 and end1 >= end2)
  end

  def overlaps?([[start1, end1], [start2, end2]]) do
     (end1 >= start2 and end1 <= end2) or (end2 >= start1 and end2 <= end1)
  end
end

"puzzle.input"
|> File.stream!()
|> Assignments.part(&Assignments.contains?/1)
|> IO.inspect()

"puzzle.input"
|> File.stream!()
|> Assignments.part(&Assignments.overlaps?/1)
|> IO.inspect()
