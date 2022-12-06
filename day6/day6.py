
def unique_chars(chars):
    """returns True when all chars passed are unique"""
    return len(set(chars)) == len(chars)

def slices(string, num):
    """Returns a zip of a string offset by 1 num times"""
    return zip(*[string[i:] for i in range(num)])

def find_unique(string, count):
    for i, chars in enumerate(slices(string, count), count):
        if unique_chars(chars):
            return i 

if __name__ == "__main__":
    with open("puzzle.input") as f:
        string = f.read()

    print(find_unique(string, 4))
    print(find_unique(string, 14))

