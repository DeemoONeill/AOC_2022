from copy import deepcopy
from itertools import starmap
from math import prod


def slice_score(slice, height):
    current_score = 0
    for tree in slice:
        if tree < height:
            current_score += 1
        else:
            current_score += 1
            break
    return current_score


def scenic_score(grid, y, x, row):
    tree_height = grid[y][x]

    west = reversed(row[:x])
    east = row[x + 1 :]
    north = reversed([row[x] for row in grid[:y]])
    south = [row[x] for row in grid[y + 1 :]]

    return prod(
        starmap(
            slice_score, ((point, tree_height) for point in (north, east, south, west))
        )
    )


def treehouse(grid):
    visible = deepcopy(grid)
    scores = deepcopy(grid)

    x_bounds = len(grid[0]) - 1
    y_bounds = len(grid) - 1

    for y, row in enumerate(grid):
        for x, height in enumerate(row):
            if y == 0 or y == y_bounds or x == 0 or x == x_bounds:
                visible[y][x] = True
                scores[y][x] = 0
            elif is_visible(grid, y, x, row, height):
                visible[y][x] = True
                scores[y][x] = scenic_score(grid, y, x, row)
            else:
                visible[y][x] = False
    return visible, scores


def is_visible(grid, y, x, row, height):
    return (
        all(tree < height for tree in row[:x])
        or all(tree < height for tree in row[x + 1 :])
        or all(tree < height for tree in [row[x] for row in grid[:y]])
        or all(tree < height for tree in [row[x] for row in grid[y + 1 :]])
    )


if __name__ == "__main__":
    with open("puzzle.input") as f:
        input = f.read()

    grid = [list(map(int, line.strip())) for line in input.split()]
    visible, scores = treehouse(grid)

    print("Part 1:", sum(sum(row) for row in visible))
    print("Part 2:", max(max(row) for row in scores))
