defmodule Monkeys do
  def parse_monkey(monkey) do
    monkey
    |> String.split("\n")
    |> Enum.map(&(String.trim(&1) |> String.split() |> parse_line))
    |> to_map
  end

  def to_map([index, starting_items, operation, modulus, if_true, if_false]) do
    %{
      index => %{
        starting: starting_items,
        operation: operation,
        mod: modulus,
        true: if_true,
        false: if_false,
        count: 0
      }
    }
  end

  def parse_line(["Monkey", num]), do: num |> Integer.parse() |> elem(0)

  def parse_line(["Starting", "items:" | items]) do
    items |> Enum.map(&(Integer.parse(&1) |> elem(0)))
  end

  def parse_line(["Operation:", "new", "=" | equation]) do
    [_, operator, operand] = equation

    fn old, mod, divisor, lcm ->
      calc =
        case operand |> Integer.parse() do
          {num, _} -> num
          :error -> old
        end
        |> operate(operator, old)
        |> div(divisor)
        |> squash_worry(divisor, lcm)

      {rem(calc, mod), calc}
    end
  end

  def parse_line([_head | rest]), do: rest |> Enum.at(-1) |> Integer.parse() |> elem(0)

  def squash_worry(num, 1, lcm), do: rem(num, lcm)
  def squash_worry(num, _divisor, _lcm), do: num

  def operate(num, "*", old), do: old * num
  def operate(num, "+", old), do: old + num

  def process_monkey([], monkey, index, _lcm, _divisor, map),
    do: %{map | index => %{monkey | starting: []}}

  def process_monkey([item | rest], monkey, index, lcm, divisor, map) do
    {remainder, worry} = item |> monkey.operation.(monkey.mod, divisor, lcm)

    {inner, to_index} =
      if remainder == 0 do
        {map[monkey.true], monkey.true}
      else
        {map[monkey.false], monkey.false}
      end

    inner = %{inner | starting: [worry | inner.starting]}

    process_monkey(rest, %{monkey | count: monkey.count + 1}, index, lcm, divisor, %{
      map
      | to_index => inner
    })
  end

  def lcm(monkey_map), do: monkey_map |> Map.values() |> Enum.map(& &1.mod) |> Enum.product()

  def calculate_worry(monkeys, cycles, divisor, lcm) do
    for _ <- 1..cycles, reduce: monkeys do
      acc ->
        for index <- Map.keys(acc) |> Enum.sort(), reduce: acc do
          inner ->
            monkey = inner[index]
            process_monkey(monkey.starting, monkey, index, lcm, divisor, inner)
        end
    end
    |> Map.to_list()
    |> Enum.map(fn {_index, map} -> map.count end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end
end

# sample_input
monkeys =
  "puzzle.input"
  |> File.read!()
  |> String.split("\n\n")
  |> Enum.map(&Monkeys.parse_monkey/1)
  |> Enum.reduce(%{}, &(&1 |> Map.merge(&2)))

monkeys
|> Monkeys.calculate_worry(20, 3, 0)
|> IO.inspect(label: "part1")

monkeys
|> Monkeys.calculate_worry(10_000, 1, Monkeys.lcm(monkeys))
|> IO.inspect(label: "part2")
