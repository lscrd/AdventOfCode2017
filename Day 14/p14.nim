import std/strutils

const
  ListSize = 256  # Knot hash list size.
  HashSize = 16   # Knot hash value size.

type

  KnotHash = object
    list: array[ListSize, int]
    lengths: seq[int]
    pos: int
    skip: int

  HashValue = array[HashSize, int]

proc initKnotHash(lengths: seq[int]): KnotHash =
  ## Initialize the Knot hash with given lengths.
  for i in 0..<ListSize:
    result.list[i] = i
  result.lengths = lengths

proc doRound(hash: var KnotHash) =
  ## Execute a round of Knot hash.
  for lg in hash.lengths:
    for idx in 0..(lg div 2 - 1):
      let i = (hash.pos + idx) mod ListSize
      let j = (hash.pos + lg - idx - 1) mod ListSize
      swap hash.list[i], hash.list[j]
    hash.pos = (hash.pos + lg + hash.skip) mod ListSize
    inc hash.skip

# Compute the knot hash for a given row.
proc knotHash(base: string; row: int): HashValue =

  # Initialize lengths.
  var lengths: seq[int]
  for c in base: lengths.add ord(c)
  lengths.add ord('-')
  for c in $row: lengths.add ord(c)
  lengths.add [17, 31, 73, 47, 23]

  var hash = initKnotHash(lengths)
  for _ in 1..64: hash.doRound()

  # Compute the dense hash.
  for i in 0..15:
    var val = 0
    for j in 0..15:
      val = val xor hash.list[16 * i + j]
    result[i] = val



### Part 1 ###

# Number of bits set in values from 0 to 15.
const BitCount = [0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4]

proc bitCount(val: HashValue): int =
  ## Return the number of bit set in the hash value.
  for b in val:
    result += BitCount[b mod 16] + BitCount[b div 16]

let base = readFile("p14.data").strip()

var count = 0
for i in 0..127:
  count += knotHash(base, i).bitCount

echo "Part 1: ", count



### Part 2 ###

type
  # Square state. An assigned square is a used square already assigned to a region.
  State {.pure.} = enum Free, Used, Assigned

  # Grid as a matrix of states.
  Grid = array[128, array[128, State]]

proc fill(grid: var Grid; row: int; hash: HashValue) =
  ## Fill a row of the grid using given hash value.
  var col = 0
  for byteVal in hash:
    var val = byteVal
    for idx in countdown(7, 0):
      grid[row][col + idx] = State(val and 1)   # Free of Used.
      val = val shr 1
    inc col, 8

proc mark(grid: var Grid; row, col: int) =
  ## Mark the cell at (row, col) and all adjacent cells.
  grid[row][col] = Assigned
  if col < 127 and grid[row][col + 1] == Used:
    grid.mark(row, col + 1)
  if row < 127 and grid[row + 1][col] == Used:
      grid.mark(row + 1, col)
  if col > 0 and grid[row][col - 1] == Used:
      grid.mark(row, col - 1)
  if row > 0 and grid[row - 1][col] == Used:
      grid.mark(row - 1, col)


var grid: Grid
for row in 0..127:
  grid.fill(row, knotHash(base, row))

var regions = 0
for row in 0..127:
  for col in 0..127:
    if grid[row][col] == Used:
      grid.mark(row, col)
      inc regions

echo "Part 2: ", regions
