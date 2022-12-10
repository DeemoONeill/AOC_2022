defmodule SignalStrength do
  def parse_instruction(instruction) do
    case instruction |> String.trim() |> String.split() do
      ["noop"] -> {1, 0}
      ["addx", num] -> {2, String.to_integer(num)}
    end
  end

  def run_instruction(instruction), do: run_instruction(instruction, 1, 1, [])

  def run_instruction({0, num}, cycle, register, cycles) do
    [{cycle, register + num} | cycles]
  end

  def run_instruction({cycles_remaining, num}, cycle, register, cycles) do
    {cycles_remaining - 1, num}
    |> run_instruction(cycle + 1, register, [{cycle, register} | cycles])
  end

  def calculate_registers([first | instructions]) do
    for instruction <- instructions, reduce: run_instruction(first) do
      [{cycle, register} | tail] ->
        run_instruction(instruction, cycle, register, tail)
    end
    |> Enum.reverse()
  end

  def calculate_screen_position(positions, hit_char \\ "#", miss_char \\ ".") do
    for {cycle, register} <- positions, reduce: [] do
      acc ->
        sprite_position = (register - 1)..(register + 1)

        if rem(cycle - 1, 40) in sprite_position do
          [hit_char | acc]
        else
          [miss_char | acc]
        end
    end
    |> Enum.reverse()
  end

  def part1(registers) do
    registers
    |> Enum.drop(19)
    |> Enum.take_every(40)
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
|> File.stream!()
|> Enum.map(&SignalStrength.parse_instruction/1)
|> SignalStrength.calculate_registers()
|> SignalStrength.part1()
|> SignalStrength.calculate_screen_position("##", "  ")
|> SignalStrength.part2()
