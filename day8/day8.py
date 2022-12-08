from copy import deepcopy

sample_input = """30373
25512
65332
33549
35390
"""
with open("puzzle.input") as f:
    grid = [list(map(int, line.strip())) for line in f.readlines()]

grid = [list(map(int, line.strip())) for line in sample_input.split()]
bool_grid = deepcopy(grid)
seen = set()

for _ in range(50):
    for row in range(len(grid)):
        for column in range(len(grid[0])):
            north = row, column -1
            east = row +1 , column
            south = row,  column + 1
            west = row-1, column

            for row_, column_ in (north, east, south, west):
                if row_ < 0 or column_ <0 or row >= len(grid)-1 or column >= len(grid[0])-1:
                    bool_grid[row][column] = True
                elif grid[row_][column_] < grid[row][column] and bool_grid[row_][column_] is True:
                    bool_grid[row][column] = True

totals = []
for row in bool_grid:
    totals.extend(row)

print(sum(filter(lambda x: x is True, totals)))
