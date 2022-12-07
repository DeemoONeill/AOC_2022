solve = fn num ->
  "puzzle.input"
  |> File.read!()
  |> String.graphemes()
  # chunks of num length offset by 1
  |> Stream.chunk_every(num, 1)
  |> Stream.map(&Enum.uniq/1)
  # with an index starting at num
  |> Stream.with_index(num)
  |> Stream.filter(&(&1 |> elem(0) |> length == num))
  |> Enum.take(1)
  |> hd
  |> elem(1)
end

solve.(4)
|> IO.inspect()

solve.(14)
|> IO.inspect()
