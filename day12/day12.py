import networkx
from networkx import shortest_path
from string import ascii_lowercase

height = dict(zip(ascii_lowercase, range(26)))
height.update(S=-1, E=26)


with open("puzzle.input") as f:
    input = f.readlines()

grid = [list(map(lambda x: height[x], line.strip())) for line in input]

graph = networkx.DiGraph()
starting_position = None
ending_position = None

y_bound = len(grid) - 1
x_bound = len(grid[0]) - 1

for y, row in enumerate(grid):
    for x, column in enumerate(row):
        north = (y-1, x)
        east = (y, x + 1)
        south = (y+1, x)
        west = (y, x - 1)
        if column == -1:
            starting_position = (y, x, -1)
        if column == 26:
            ending_position = (y,x, 26)
        for (y_, x_) in [north, east, south, west]:
            if y_ < 0 or y_ > y_bound or x_ < 0 or x_ > x_bound:
                continue
            item = grid[y_][x_]
            if column >= item:
                graph.add_edge((y,x, column), (y_, x_, item))
                if abs(column - item) <= 1:
                    graph.add_edge((y_, x_, item), (y, x, column))


path = shortest_path(graph, starting_position, ending_position)
print("part 1", len(path)-1)

path_lengths = []
for a_position in filter(lambda x: x[2] <= 0, graph.nodes):
    try:
        path = shortest_path(graph, a_position, ending_position)
        path_lengths.append(len(path) -1)
    except:
        continue
print("part 2", min(path_lengths))

