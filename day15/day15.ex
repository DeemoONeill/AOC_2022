example = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3"

defmodule Beacons do
  def calculate_manhattan({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def collect(num, list) do
    receive do
      {x, y} = point ->
        if y == num do
          collect(num, [point | list])
        else
          collect(num, list)
        end
    after
      500 -> list |> MapSet.new()
    end
  end
end

input =
  "puzzle.input"
  |> File.read!()

points =
  ~r"Sensor at x=([\d-]+), y=([\d-]+): closest beacon is at x=([\d-]+), y=([\d-]+)"
  |> Regex.scan(input)
  |> Enum.map(fn [_ | values] ->
    [sensor_x, sensor_y, beacon_x, beacon_y] = values |> Enum.map(&String.to_integer/1)
    [{sensor_x, sensor_y}, {beacon_x, beacon_y}]
  end)

beacon_map =
  for [sensor, beacon] <- points, reduce: %{} do
    map ->
      Map.put(map, sensor, "S")
      |> Map.put(beacon, "B")
  end

my_pid = self()

for [sensor, beacon] <- points do
  distance = Beacons.calculate_manhattan(sensor, beacon)

  spawn(fn ->
    for {x_mod, y_mod} = mods <- Stream.zip(0..distance, distance..0), reduce: [] do
      acc ->
        {sensor_x, sensor_y} = sensor

        for y <- (sensor_y - y_mod)..(sensor_y + y_mod), reduce: [] do
          acc ->
            Enum.uniq([{sensor_x - x_mod, y}, {sensor_x + x_mod, y}])
            |> Enum.map(&send(my_pid, &1))

            []
        end
    end
  end)
end

Beacons.collect(10, [])
|> MapSet.difference(MapSet.new(Map.keys(beacon_map)))
|> Enum.count()
|> IO.inspect()
