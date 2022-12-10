defmodule SignalStrength do
  def parse_instruction(instruction) do
    case instruction |> String.trim() |> String.split() do
      ["noop"] -> {1, 0}
      ["addx", num] -> {2, String.to_integer(num)}
    end
  end

  def run_instruction({0, num}, register, cycle, cycles) do
    [{cycle, register + num} | cycles]
  end

  def run_instruction({cycles_remaining, num}, register, cycle, cycles) do
    {cycles_remaining - 1, num}
    |> run_instruction(register, cycle + 1, [{cycle, register} | cycles])
  end

  def calculate_registers(instructions) do
    for instruction <- instructions, reduce: [] do
      [] ->
        SignalStrength.run_instruction(instruction, 1, 1, [])

      [{cycle, register} | tail] ->
        SignalStrength.run_instruction(instruction, register, cycle, tail)
    end
    |> Enum.reverse()
  end

  def calculate_screen_position(positions) do
    for {{_, register}, cycle} <- positions |> Enum.with_index(), reduce: [] do
      acc ->
        sprite_position = (register - 1)..(register + 1)

        if rem(cycle, 40) in sprite_position do
          ["#" | acc]
        else
          ["." | acc]
        end
    end
    |> Enum.reverse()
  end

  def part1(registers) do
    registers
    |> Enum.filter(&((&1 |> elem(0)) in [20, 60, 100, 140, 180, 220]))
    |> Enum.map(fn {cycle, register} -> cycle * register end)
    |> Enum.sum()
    |> IO.inspect(label: "part1")

    registers
  end

  def part2(screen) do
    screen
    |> Enum.chunk_every(40, 40, :discard)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
    |> IO.puts()
  end
end

"puzzle.input"
|> File.read!()
|> String.split("\n")
|> Enum.map(&SignalStrength.parse_instruction/1)
|> SignalStrength.calculate_registers()
|> SignalStrength.part1()
|> SignalStrength.calculate_screen_position()
|> SignalStrength.part2()
