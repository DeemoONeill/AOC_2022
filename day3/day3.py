import string

SCORES = dict(zip(string.ascii_letters, range(1, 100)))


def split_strings(row):
    lenstr = len(row) // 2
    return row[:lenstr], row[lenstr:]


def intersections(*tups):
    tups = iter(tups)
    first = set(next(tups))
    for tup in tups:
        first &= set(tup)
    return first.pop()


def part1(puzzle_lines):
    return sum(SCORES[intersections(*tup)] for tup in map(split_strings, puzzle_lines))


def part2(puzzle_lines):
    lines = [line.strip() for line in puzzle_lines]
    zipped = zip(lines[::3], lines[1::3], lines[2::3])
    return sum(SCORES[intersections(*tup)] for tup in zipped)


if __name__ == "__main__":
    with open("puzzle.input") as f:
        puzzle_lines = f.readlines()

    print("part1:", part1(puzzle_lines))
    print("part2:", part1(puzzle_lines))
