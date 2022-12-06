solve = fn num ->
  "puzzle.input"
  |> File.read!()
  |> String.graphemes()
  |> Stream.chunk_every(num, 1) # chunks of num length offset by 1
  |> Stream.with_index(num) # with an index starting at num
  |> Stream.filter(fn {str, _index} ->
    MapSet.new(str)
    |> MapSet.to_list()
    |> length() == length(str)
  end)
  |> Enum.take(1)
  |> hd
  |> elem(1)
  |> IO.inspect()
end
:timer.tc(fn ->
solve.(4) end)|> IO.inspect()

:timer.tc(fn ->
solve.(14) end)|> IO.inspect()
