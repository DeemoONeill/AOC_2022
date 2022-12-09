defmodule Rope do
  def parse_instruction(line) do
    case line |> String.split() do
      ["L", num] -> {-String.to_integer(num), 0, -1}
      ["R", num] -> {String.to_integer(num), 0, 1}
      ["U", num] -> {0, String.to_integer(num), 1}
      ["D", num] -> {0, -String.to_integer(num), -1}
    end
  end

  def move(head, tail, {0, 0, _dir}, tail_positions) do
    {head, tail, tail_positions}
  end

  def move(head, tail, {0, y, dir}, tail_positions) do
    # move up or down
    {head, tail} = move_vertical(head, tail, dir)
    move(head, tail, {0, y - dir, dir}, [tail | tail_positions])
  end

  def move(head, tail, {x, 0, dir}, tail_positions) do
    # move left or right
    {head, tail} = move_horizontal(head, tail, dir)
    move(head, tail, {x - dir, 0, dir}, [tail | tail_positions])
  end

  def move_horizontal({headx, heady}, {tailx, taily} = tail, x_direction) do
    head = {headx + x_direction, heady}

    action =
      head
      |> calculate_magnitude(tail)

    tail =
      case action do
        :stay_put ->
          tail

        :move ->
          {tailx + x_direction, taily}

        :move_diagonally ->
          {tailx + x_direction, heady}
      end

    {head, tail}
  end

  def move_vertical({headx, heady}, {tailx, taily} = tail, y_direction) do
    head = {headx, heady + y_direction}

    action =
      head
      |> calculate_magnitude(tail)

    tail =
      case action do
        :stay_put ->
          tail

        :move ->
          {tailx, taily + y_direction}

        :move_diagonally ->
          {headx, taily + y_direction}
      end

    {head, tail}
  end

  def calculate_magnitude({headx, heady}, {tailx, taily}) do
    magnitude =
      ((headx - tailx) ** 2 + (heady - taily) ** 2)
      |> :math.sqrt()

    case magnitude do
      mag when mag < 2 -> :stay_put
      mag when mag == 2.0 -> :move
      mag when mag > 2.0 -> :move_diagonally
    end
  end
end

_example_input =
  "R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2"
  |> String.split("\n")
  |> Enum.map(&Rope.parse_instruction/1)

input =
  "puzzle.input"
  |> File.read!()
  |> String.split("\n")
  |> Enum.map(&Rope.parse_instruction/1)

head = {0, 0}
tail = {0, 0}

for instruction <- input, reduce: {head, tail, []} do
  {head, tail, rope_positions} -> Rope.move(head, tail, instruction, rope_positions)
end
|> elem(2)
|> Enum.uniq()
|> Enum.count()
|> IO.inspect()
