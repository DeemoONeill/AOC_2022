import string

scores = {letter: score for score, letter in enumerate(string.ascii_letters, 1)}


def split_strings(row):
    lenstr = len(row) // 2
    return row[:lenstr], row[lenstr:]


def intersections(*tups):
    tups = iter(tups)
    first = set(next(tups))
    for tup in tups:
        first &= set(tup)
    return first.pop()


with open("puzzle.input") as f:
    print(
        "part1:",
        sum(scores[intersections(*tup)] for tup in map(split_strings, f.readlines())),
    )


with open("puzzle.input") as f:
    lines = [line.strip() for line in f.readlines()]
    zipped = zip(lines[::3], lines[1::3], lines[2::3])
    print(
        "part2:",
        sum(scores[intersections(*tup)] for tup in zipped),
    )
