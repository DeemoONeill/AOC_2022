
def unique_chars(chars, length):
    return len(set(chars)) == length

def slices(string, num):
    return zip(*[string[i:] for i in range(num)])

def find_unique(string, count):
    for i, chars in enumerate(slices(string, count), 1):
        if unique_chars(chars, count):
            return i+count-1

if __name__ == "__main__":
    with open("puzzle.input") as f:
        string = f.read()

    print(find_unique(string, 4))
    print(find_unique(string, 14))

