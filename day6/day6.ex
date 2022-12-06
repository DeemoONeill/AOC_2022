defmodule Signal do
  def find_signal([_head | tail] = input, num_chars) do
    if unique_chars?(input, num_chars) == num_chars do
      1
    else
      tail
      |> find_signal(num_chars, 2)
    end
  end

  defp find_signal([], _num_chars, count), do: count

  defp find_signal([_head | tail] = input, num_chars, count) do
    if unique_chars?(input, num_chars) do
      find_signal([], num_chars, count + num_chars - 1)
    else
      find_signal(tail, num_chars, count + 1)
    end
  end

  def unique_chars?(input, num_chars) do
    MapSet.new(
      input
      |> Enum.take(num_chars)
    )
    |> MapSet.to_list()
    |> length() == num_chars
  end
end

"puzzle.input"
|> File.read!()
|> String.graphemes()
|> Signal.find_signal(4)
|> IO.puts()

"puzzle.input"
|> File.read!()
|> String.graphemes()
|> Signal.find_signal(14)
|> IO.puts()
