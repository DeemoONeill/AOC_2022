

defmodule Rocker_Paper_Scissors do

  def calculate(filename, scores_matrix) do
    File.stream!(filename)
    |> score_lines(scores_matrix)
    |> Enum.sum
  end

  def score_lines(lines, scores_matrix) do
    for line <- lines do
      scores_matrix[String.split(line)|>List.to_tuple()]
    end
  end
end


part_1_scores_matrix = %{
  {"A", "X"} => 4, {"B", "X"} => 1, {"C", "X"} => 7,
  {"A", "Y"} => 8, {"B", "Y"} => 5, {"C", "Y"} => 2,
  {"A", "Z"} => 3, {"B", "Z"} => 9, {"C", "Z"} => 6,
}

part_2_scores_matrix = %{
  {"A", "X"} => 3, {"B", "X"} => 1, {"C", "X"} => 2,
  {"A", "Y"} => 4, {"B", "Y"} => 5, {"C", "Y"} => 6,
  {"A", "Z"} => 8, {"B", "Z"} => 9, {"C", "Z"} => 7,
}

# part 1
# A & X = Rock
# B & Y = Paper
# C & Z = Scissors

"puzzle.input"
|>Rocker_Paper_Scissors.calculate(part_1_scores_matrix)
|> IO.inspect()

#part 2
# X = lose
# y = draw
# z = win

"puzzle.input"
|>Rocker_Paper_Scissors.calculate(part_2_scores_matrix)
|> IO.inspect()
