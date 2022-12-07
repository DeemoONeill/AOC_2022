sample_input = "$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"

test_map = %{
  "/" => %{"a" => %{"e" => %{"i" => 584}, "b.txt" => 14_848_514}, "d" => %{"j" => 14_848_514}}
}

defmodule FileSystem do
  def update_map(nil, [], input) do
    Map.new([input])
  end

  def update_map(map, [], {key, value} = input) do
    # IO.inspect(map, label: "map")
    # IO.inspect(input, label: "update input")

    map
    |> Map.put(key, value)
  end

  def update_map(map, [cwd | path], input) do
    %{map | cwd => update_map(map[cwd], path, input)}
  end

  def sum_directories(map) do
    for {key, value} <- map |> Map.to_list(), reduce: %{} do
      acc ->
        case {key, value} do
          {k, v} when is_map(v) -> acc |> update_size(sum_directories(v, [k], acc))
        end
    end
    |> IO.inspect()
  end

  def sum_directories(map, path, acc) do
    for {key, value} <- map |> Map.to_list(), reduce: acc do
      acc ->
        case {key, value} do
          {dir, contents} when is_map(contents) ->
            update_size(acc, sum_directories(contents, [dir | path], acc))

          {_, num} ->
            acc
            |> update_size(
              for dir <- path do
                {dir, num}
              end
              |> Map.new()
            )
        end
    end
  end

  def update_size(map_to_update, map) do
    for {key, value} <- map, reduce: %{} do
      acc ->
        num = acc |> Map.get(key, 0)

        acc
        |> Map.put(key, num + value)
    end
  end
end

{_, file_system} =
  for instruction <- String.split(sample_input, "\n"), reduce: {[], %{}} do
    acc ->
      {path, map} = acc

      case instruction |> String.split() do
        ["$", "cd", ".."] ->
          {path |> tl, map}

        ["$", "cd", dir] ->
          {[dir | path], map |> FileSystem.update_map(path |> Enum.reverse(), {dir, %{}})}

        ["$", "ls"] ->
          {path, map}

        ["dir", _folder] ->
          {path, map}

        [filesize, filename] ->
          {path,
           map
           |> FileSystem.update_map(
             path |> Enum.reverse(),
             {filename, String.to_integer(filesize)}
           )}

        _ ->
          {path, map}
      end
  end

file_system
|> FileSystem.sum_directories()
