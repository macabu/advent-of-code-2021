import strutils
import sequtils
import algorithm

type
    Point* = object
        value*, row*, col*: int

proc findAdjacentLocations(rows: seq[string], i: int, j: int): seq[Point] =
    let prevOnRow = if j != 0: parseInt($rows[i][j-1]) else: parseInt($rows[i][j])
    let nextOnRow = if j != rows[0].len()-1: parseInt($rows[i][j+1]) else: parseInt($rows[i][j])
    let prevOnCol = if i != 0: parseInt($rows[i-1][j]) else: parseInt($rows[i][j])
    let nextOnCol = if i != rows.len()-1: parseInt($rows[i+1][j]) else: parseInt($rows[i][j])

    # Handle top-left corner
    if i == 0 and j == 0:
        return @[
            Point(value: nextOnCol, row: i+1, col: j),
            Point(value: nextOnRow, row: i, col: j+1),
        ]

    # Handle top-right corner
    elif i == 0 and j == rows[0].len()-1:
        return @[
            Point(value: nextOnCol, row: i+1, col: j),
            Point(value: prevOnRow, row: i, col: j-1),
        ]

    # Handle bottom-left corner
    elif i == rows.len()-1 and j == 0:
        return @[
            Point(value: prevOnCol, row: i-1, col: j),
            Point(value: nextOnRow, row: i, col: j+1),
        ]

    # Handle bottom-right corner
    elif i == rows.len()-1 and j == rows[0].len()-1:
        return @[
            Point(value: prevOnCol, row: i-1, col: j),
            Point(value: prevOnRow, row: i, col: j-1),
        ]

    # Handle top side
    elif i == 0 and j != rows[0].len()-1:
        return @[
            Point(value: prevOnRow, row: i, col: j-1),
            Point(value: nextOnRow, row: i, col: j+1),
            Point(value: nextOnCol, row: i+1, col: j),
        ]

    # Handle left side
    elif i != 0 and j == 0:
        return @[
            Point(value: prevOnCol, row: i-1, col: j),
            Point(value: nextOnRow, row: i, col: j+1),
            Point(value: nextOnCol, row: i+1, col: j),
        ]

    # Handle right side
    elif i != 0 and j == rows[0].len()-1:
        return @[
            Point(value: prevOnCol, row: i-1, col: j),
            Point(value: prevOnRow, row: i, col: j-1),
            Point(value: nextOnCol, row: i+1, col: j),
        ]

    # Handle bottom side
    elif i == rows.len()-1 and j != 0:
        return @[
            Point(value: prevOnCol, row: i-1, col: j),
            Point(value: prevOnRow, row: i, col: j-1),
            Point(value: nextOnRow, row: i, col: j+1),
        ]

    # Handle middle of the grid
    else:
        return @[
            Point(value: prevOnCol, row: i-1, col: j),
            Point(value: prevOnRow, row: i, col: j-1),
            Point(value: nextOnRow, row: i, col: j+1),
            Point(value: nextOnCol, row: i+1, col: j),
        ]

    return @[]

proc findLowPoints(rows: seq[string]): seq[Point] =
    var lowPoints: seq[Point] = @[]

    for i in 0..rows.len()-1:
        for j in 0..rows[0].len()-1:
            let current = parseInt($rows[i][j])
            let adjacents = findAdjacentLocations(rows, i, j)

            if filter(adjacents, proc (p: Point): bool = p.value <= current).len() > 0:
                continue

            lowPoints.add(Point(value: current, row: i, col: j))

    return lowPoints

proc pointMatches(p1: Point, p2: Point): bool =
    return p1.col == p2.col and p1.row == p2.row and p1.value == p2.value

proc pointAlreadySeen(aa: seq[Point], pointToAdd: Point): bool =
    return filter(aa, proc (existingPoint: Point): bool = pointMatches(existingPoint, pointToAdd)).len() > 0

proc walkAdjacentLocations(rows: seq[string], aa: seq[Point]): int =
    for a in aa:
        let newAdjacents = findAdjacentLocations(rows, a.row, a.col)
        let filteredLocs = filter(newAdjacents, proc (p: Point): bool = not pointAlreadySeen(aa, p) and p.value != 9)
        if filteredLocs.len() > 0:
            return walkAdjacentLocations(rows, concat(aa, filteredLocs))
    return aa.len()

proc findBasins(rows: seq[string]): seq[int] =
    var basins: seq[int] = @[]

    for i in 0..rows.len()-1:
        for j in 0..rows[0].len()-1:
            let current = parseInt($rows[i][j])
            let adjacents = findAdjacentLocations(rows, i, j)

            if filter(adjacents, proc (p: Point): bool = p.value <= current).len() > 0:
                continue

            let walked = walkAdjacentLocations(rows, @[Point(value: current, row: i, col: j)])

            basins.add(walked)

    return basins

proc partOne(rows: seq[string]): int =
    let lowPoints = findLowPoints(rows)
    var total = 0
    for elem in lowPoints:
        total += (1 + elem.value)
    return total

proc partTwo(rows: seq[string]): int =
    let basins = sorted(findBasins(rows), system.cmp[int], Descending)
    return basins[0] * basins[1] * basins[2]

let rows = readFile("input.txt").splitLines()

echo "Part 1: ", partOne(rows)
echo "Part 2: ", partTwo(rows)
