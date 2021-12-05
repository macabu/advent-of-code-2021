def remove_non_lines(lines):
    valid_lines = []

    for line in lines:
        [begin, end] = line.strip().split(" -> ")
        [x1, y1] = begin.split(",")
        [x2, y2] = end.split(",")

        if x1 == x2 or y1 == y2:
            valid_lines.append(line)

    return valid_lines

def format_lines(lines):
    formatted = []

    for line in lines:
        [begin, end] = line.strip().split(" -> ")
        [x1, y1] = begin.split(",")
        [x2, y2] = end.split(",")

        formatted.append({
            "x1": int(x1), "x2": int(x2),
            "y1": int(y1), "y2": int(y2),
        })

    return formatted

def find_max_coordinates(lines):
    max_x = 0
    max_y = 0

    for line in lines:
        tmp_max_x = max(line["x1"], line["x2"])
        if tmp_max_x > max_x:
            max_x = tmp_max_x

        tmp_max_y = max(line["y1"], line["y2"])
        if tmp_max_y > max_y:
            max_y = tmp_max_y

    return (max_x, max_y)

def calculate_hv_overlaps(lines, max_coords):
    overlaps = [[0] * (max_coords[1]+1) for _ in range(max_coords[0]+1)]

    for line in lines:
        if line["x1"] == line["x2"]:
            min_y = min(line["y1"], line["y2"])
            max_y = max(line["y1"], line["y2"])

            end = max_y
            while end >= min_y:
                overlaps[line["x1"]][end] += 1
                end -= 1

        if line["y1"] == line["y2"]:
            min_x = min(line["x1"], line["x2"])
            max_x = max(line["x1"], line["x2"])

            end = max_x
            while end >= min_x:
                overlaps[end][line["y1"]] += 1
                end -= 1

    return overlaps

def count_overlaps(overlaps, greater_than = 1):
    count = 0

    for x in overlaps:
        for y in x:
            if y > greater_than:
                count += 1

    return count

def calculate_hvd_overlaps(lines, max_coords):
    overlaps = calculate_hv_overlaps(lines, max_coords)

    for line in lines:
        if line["x1"] != line["x2"] and line["y1"] != line["y2"]: # add points where y = m*x + b
            m = (line["y2"] - line["y1"]) / (line["x2"] - line["x1"])
            b = line["y2"] - m * line["x2"]

            min_x = min(line["x1"], line["x2"])
            max_x = max(line["x1"], line["x2"])
            min_y = min(line["y1"], line["y2"])
            max_y = max(line["y1"], line["y2"])

            for x in range(min_x, max_x+1):
                for y in range(min_y, max_y+1):
                    if y == ((m * x) + b):
                        overlaps[x][y] += 1

    return overlaps

def part_one(input):
    lines = remove_non_lines(input)
    lines = format_lines(lines)
    max_coords = find_max_coordinates(lines)
    overlaps = calculate_hv_overlaps(lines, max_coords)
    count = count_overlaps(overlaps)
    print("Part 1 - Overlapping Horizontal/Vertical Lines:", count)

def part_two(input):
    lines = format_lines(input)
    max_coords = find_max_coordinates(lines)
    overlaps = calculate_hvd_overlaps(lines, max_coords)
    count = count_overlaps(overlaps)
    print("Part 2 - Overlapping Horizontal/Vertical/Diagonal Lines:", count)

if __name__ == "__main__":
    input = open("input.txt", "r")
    lines = input.readlines()

    part_one(lines)
    part_two(lines)
