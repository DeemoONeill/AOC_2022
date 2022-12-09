defmodule Rope do
  def parse_instruction(line) do
    case line |> String.split() do
      ["L", num] -> {-String.to_integer(num), 0, -1}
      ["R", num] -> {String.to_integer(num), 0, 1}
      ["U", num] -> {0, String.to_integer(num), 1}
      ["D", num] -> {0, -String.to_integer(num), -1}
    end
  end

  def move_whole_rope(rope, move_func) do
    for knot <- rope, reduce: [] do
      [] ->
        [knot]

      [head | _] = processed ->
        tail = move_func.(head, knot)
        [tail | processed]
    end
  end

  def move(rope, {0, 0, _dir}, tail_positions) do
    {rope, tail_positions}
  end

  def move([{headx, heady} | tail], {0, y, dir}, tail_positions) do
    # move up or down

    head = {headx, heady + dir}
    [tail | _] = rope = move_whole_rope([head | tail], &move_knot/2)

    move(rope |> Enum.reverse(), {0, y - dir, dir}, tail_positions |> MapSet.put(tail))
  end

  def move([{headx, heady} | tail], {x, 0, dir}, tail_positions) do
    # move left or right
    head = {headx + dir, heady}
    [tail | _] = rope = move_whole_rope([head | tail], &move_knot/2)

    move(rope |> Enum.reverse(), {x - dir, 0, dir}, tail_positions |> MapSet.put(tail))
  end

  def move_knot({headx, heady} = head, {tailx, taily} = tail) do
    if calculate_magnitude(head, tail) <= 1.5 do
      tail
    else
      {tailx + direction(headx, tailx), taily + direction(heady, taily)}
    end
  end

  def direction(head, tail) when head == tail, do: 0
  def direction(head, tail) when head < tail, do: -1
  def direction(head, tail) when head > tail, do: 1

  def calculate_magnitude({headx, heady}, {tailx, taily}) do
    ((headx - tailx) ** 2 + (heady - taily) ** 2)
    |> :math.sqrt()
  end

  def part(instructions, num) do
    rope = List.duplicate({0, 0}, num)

    for instruction <- instructions, reduce: {rope, MapSet.new()} do
      {rope, locations} -> move(rope, instruction, locations)
    end
    |> elem(1)
    |> Enum.count()
  end
end

input =
  "puzzle.input"
  |> File.read!()
  |> String.split("\n")

input
|> Enum.map(&Rope.parse_instruction/1)
|> Rope.part(2)
|> IO.inspect(label: "Part 1")

input
|> Enum.map(&Rope.parse_instruction/1)
|> Rope.part(10)
|> IO.inspect(label: "Part 2")
