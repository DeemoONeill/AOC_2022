defmodule FS do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def get(key) do
    Agent.get(__MODULE__, &(&1 |> Map.get(key)))
  end

  def put(map, key) do
    Agent.update(__MODULE__, &%{&1 | key => map})
  end
end

defmodule FileSystem do
  def parse_instructions(instructions) do
    instructions
    |> Enum.map(&String.split/1)
    |> Enum.reduce({"", %{}}, &parse_instruction/2)
    |> elem(1)
  end

  def calculate_totals(file_tree) do
    file_tree
    |> FS.start_link()

    sumdir("/")
    FS.value()
  end

  def dirs_under_N_size(file_tree, n) do
    file_tree
    |> Map.to_list()
    |> Enum.map(&(elem(&1, 1) |> Map.get("total")))
    |> Enum.filter(&(&1 <= n))
    |> Enum.sum()
  end

  def space_needed(file_tree, total_space, total_needed) do
    space_used =
      file_tree
      |> Map.get("/")
      |> Map.get("total")

    total_needed - (total_space - space_used)
  end

  defp parse_instruction(["$", "cd", ".."], {path, map}) do
    {path |> String.split("/") |> tl |> Enum.join("/"), map}
  end

  defp parse_instruction(["$", "cd", "/"], {_path, map}) do
    {"/", Map.put(map, "/", %{})}
  end

  defp parse_instruction(["$", "cd", dir], {path, map}) do
    cwd = dir <> "/" <> path
    {cwd, Map.put(map, cwd, %{})}
  end

  defp parse_instruction(["$", "ls"], accumulator), do: accumulator

  defp parse_instruction(["dir", folder], {cwd, map}) do
    dir = Map.get(map, cwd, %{})

    folders = [folder <> "/" <> cwd | Map.get(dir, "dirs", [])]

    {cwd, Map.put(map, cwd, Map.put(dir, "dirs", folders))}
  end

  defp parse_instruction([filesize, _], {cwd, map}) do
    dir = Map.get(map, cwd, %{})

    files = [String.to_integer(filesize) | Map.get(dir, "files", [])]

    {cwd, Map.put(map, cwd, Map.put(dir, "files", files))}
  end

  def sumdir(key) do
    FS.get(key)
    |> calc_total(key)
  end

  defp file_total(%{"total" => total}), do: total
  defp file_total(%{"files" => list}), do: list |> Enum.sum()
  defp file_total(_map), do: 0

  defp dir_total(%{"total" => total}), do: total
  defp dir_total(%{"dirs" => list}), do: list |> Enum.map(&sumdir/1) |> Enum.sum()
  defp dir_total(_map), do: 0

  defp calc_total(dir, key) do
    total = file_total(dir) + dir_total(dir)
    dir |> Map.put("total", total) |> FS.put(key)
    total
  end
end

# sample_input

"puzzle.input"
|> File.stream!()
|> FileSystem.parse_instructions()
|> FileSystem.calculate_totals()
|> FileSystem.dirs_under_N_size(100_000)
|> IO.inspect(label: "part 1")

# part2

FS.value()
|> Enum.map(&(elem(&1, 1) |> Map.get("total")))
|> Enum.filter(&(&1 >= FS.value() |> FileSystem.space_needed(70_000_000, 30_000_000)))
|> Enum.min()
|> IO.inspect(label: "part 2")
