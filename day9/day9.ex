defmodule Rope do
  def parse_instruction(line) do
    case line |> String.split() do
      ["L", num] -> {-String.to_integer(num), 0, -1}
      ["R", num] -> {String.to_integer(num), 0, 1}
      ["U", num] -> {0, String.to_integer(num), 1}
      ["D", num] -> {0, -String.to_integer(num), -1}
    end
  end

  def move_whole_rope(rope, dir, move_func) do
    for knot <- rope, reduce: [] do
      [] ->
        [knot] |> IO.inspect()

      [head | _] = processed ->
        tail = move_func.(head, knot, dir)
        [tail |> IO.inspect() | processed]
    end
  end

  def move(rope, {0, 0, _dir}, tail_positions) do
    {rope, tail_positions}
  end

  def move([{headx, heady} | tail], {0, y, dir}, tail_positions) do
    # move up or down
    head = {headx, heady + dir}
    [tail | _] = rope = move_whole_rope([head | tail], dir, &move_vertical/3)

    move(rope |> Enum.reverse(), {0, y - dir, dir}, tail_positions |> MapSet.put(tail))
  end

  def move([{headx, heady} | tail], {x, 0, dir}, tail_positions) do
    # move left or right
    head = {headx + dir, heady}
    [tail | _] = rope = move_whole_rope([head | tail], dir, &move_horizontal/3)
    move(rope |> Enum.reverse(), {x - dir, 0, dir}, tail_positions |> MapSet.put(tail))
  end

  def move_horizontal(head, [inner], x_direction) do
    move_horizontal(head, inner, x_direction)
  end

  def move_horizontal({_headx, heady} = head, {tailx, taily} = tail, x_direction) do
    action =
      head
      |> calculate_magnitude(tail)

    case action do
      :stay_put ->
        tail

      :move ->
        {tailx + x_direction, taily}

      :move_diagonally ->
        {tailx + x_direction, heady}

      :move_towards ->
        {tailx + x_direction, heady - x_direction}
    end
  end

  def move_vertical(head, [inner], y_direction) do
    move_vertical(head, inner, y_direction)
  end

  def move_vertical({headx, _heady} = head, {tailx, taily} = tail, y_direction) do
    action =
      head
      |> calculate_magnitude(tail)

    case action do
      :stay_put ->
        tail

      :move ->
        {tailx, taily + y_direction}

      :move_diagonally ->
        {headx, taily + y_direction}

      :move_towards ->
        {tailx + y_direction, taily + y_direction}
    end
  end

  def calculate_magnitude({headx, heady}, {tailx, taily}) do
    magnitude =
      ((headx - tailx) ** 2 + (heady - taily) ** 2)
      |> :math.sqrt()

    case magnitude do
      mag when mag == 0.0 ->
        :stay_put

      mag when mag == 1.0 ->
        :stay_put

      mag when mag == 1.4142135623730951 ->
        :stay_put

      mag when mag == 2.0 ->
        :move

      mag when mag == 2.23606797749979 ->
        :move_diagonally

      mag when mag == 2.8284271247461903 ->
        :move_diagonally

      mag ->
        :move_diagonally
    end
  end
end

example_input =
  "R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20"
  |> String.split("\n")
  |> Enum.map(&Rope.parse_instruction/1)

input =
  "puzzle.input"
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&Rope.parse_instruction/1)

knot = {0, 0}

rope = List.duplicate(knot, 2)

for instruction <- input, reduce: {rope, MapSet.new()} do
  {rope, rope_positions} -> Rope.move(rope, instruction, rope_positions)
end
|> elem(1)
|> Enum.count()
|> IO.inspect()
