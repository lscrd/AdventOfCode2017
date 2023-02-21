import std/[strutils, tables]

var grid: seq[string]

# Load grid.
for line in lines("p19.data"):
  grid.add line

var path: seq[char]
let nrows = grid.len
let ncols = grid[0].len

var visited: seq[string]
let spaces = repeat(' ', ncols)
for row in 1..nrows: visited.add spaces

type Direction = (int, int)

const
  NextDir = {(1, 0): (0, 1), (0, 1): (-1, 0),
             (-1, 0): (0, -1), (0, -1): (1, 0)}.toTable
  Dirs = {(1, 0): 'V', (0, 1): 'H', (-1, 0): 'V', (0, -1): 'H'}.toTable


# Find the starting point in row 0.
var col = 0
for c in grid[0]:
  if c == '|':
    break
  inc col

# Find the path.
var row = 0
var dx = 1
var dy = 0
visited[0][col] = 'V'
var steps = 1
var lastDir: Direction
while true:
  # Go in the same direction.
  let d = Dirs[(dx, dy)]  # 'H' or 'V'.
  while true:
    let nextRow = row + dx
    let nextCol = col + dy
    if nextRow < 0 or nextRow == nrows or nextCol < 0 or nextCol == ncols:
      break
    if visited[nextRow][nextCol] == d:
      break   # Already encountered in the same direction ('H' or 'V').
    let val = grid[nextRow][nextCol]
    if val == ' ':
      break
    if val.isUpperAscii():
      path.add val
    # Other values allow to continue in the same direction.
    row = nextRow
    col = nextCol
    visited[row][col] = d
    lastDir = (dx, dy)
    inc steps

  # Change direction.
  let val = grid[row][col]
  if val == '+' or val.isUpperAscii():
      (dx, dy) = NextDir[(dx, dy)]
      if val != '+' and (dx, dy) == lastDir:
        break   # Reached the end.
  else:
    break       # Reached the end.


### Part 1 ###
echo "Part 1: ", path.join()

### Part 2 ###
echo "Part 2: ", steps
