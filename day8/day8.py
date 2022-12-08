from copy import deepcopy


sample_input = """30373
25512
65332
33549
35390"""

# with open("puzzle.input") as f:
#     sample_input = f.read()

grid = [list(map(int, line.strip())) for line in sample_input.split()]

visible = deepcopy(grid)
scores = deepcopy(grid)

x_bounds = len(grid[0]) -1
y_bounds = len(grid) - 1

def slice_score(slice):
    current_score = 1
    for tree in slice:
        if tree < item:
            current_score += 1
        else:
            break
    return current_score

def scenic_score(grid, y, x, row):
    value= grid[y][x]
    total = 1

    slices = [reversed(row[:x]), row[x+1:], reversed([row[x] for row in grid[:y]]), [row[x] for row in grid[y+1:]]]

    for score in map(slice_score, slices):
        total *=score

    return total




for y, row in enumerate(grid):
    for x, item in enumerate(row):
        if y == 0 or y == y_bounds or x == 0 or x == x_bounds:
           visible[y][x] = True
           scores[y][x] = 0
        elif (
            all(tree < item for tree in row[:x])
            or all(tree < item for tree in row[x+1:])
            or all(tree < item for tree in [row[x] for row in grid[:y]]) 
            or all(tree < item for tree in [row[x] for row in grid[y+1:]])
            ):
            visible[y][x] = True
            scores[y][x] = scenic_score(grid, y, x, row)
        else:
            visible[y][x] = False
            scores[y][x] = scenic_score(grid, y, x, row)


total = []
for row in visible:
    total.extend(row)

print(sum(filter(lambda x: x is True, total)))

highest_score = max(max(row) for row in scores)
print(highest_score, sep="\n")