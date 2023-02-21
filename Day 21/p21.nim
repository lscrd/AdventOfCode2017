import std/[sequtils, strutils, tables]

type
  Grid = seq[string]
  Rules = Table[Grid, ref Grid]  # Maps patterns to outputs.

proc flip(grid: Grid): Grid =
  ## Return a flipped pattern grid.
  for i in countdown(grid.high, 0):
    result.add grid[i]

proc transpose(grid: Grid): Grid =
  ## Return a transposed pattern grid.
  result = newSeqWith(grid.len, newString(grid.len))
  for i in 0 .. grid.high:
    for j in 0 .. grid.high:
      result[j][i] = grid[i][j]

iterator expandPattern(patternStr, outputStr: string): (Grid, ref Grid) =
  ## Expand the pattern strings using flip and transpose operations
  ## (rather than flip and rotate).
  ## Yield the couples (pattern, output).
  let output = new(Grid)
  output[] = outputStr.split('/')
  var pattern = patternStr.split('/')
  yield (pattern, output)
  pattern = pattern.flip()
  yield (pattern, output)
  for i in 1..3:
    pattern = pattern.transpose()
    yield (pattern, output)
    pattern = pattern.flip()
    yield (pattern, output)

iterator squares(grid: Grid; size, count: int): Grid =
  ## Split the data into "count" squares of given size.
  for n in 0..(count * count - 1):
    var result: Grid
    let rowstart = (n div count) * size
    for iRow in rowstart..<(rowstart + size):
      var row: string
      let colstart = (n mod count) * size
      for iCol in colstart..<colstart + size:
        row.add grid[iRow][iCol]
      result.add row
    yield result

proc merge(grids: seq[ref Grid]): Grid =
  ## Merge a list of squares in a row.
  let size = grids[0][].len
  for row in 0..<size:
    result.add ""   # Add a row.
    for grid in grids:
      result[row].add grid[row]

proc run(rules: Rules; n: int): int =
  ## Execute "n" iterations.
  ## Return the number of pixels.

  var output = ".#./..#/###".split('/')

  for _ in 1..n:
    let length = output.len
    let size = if (length and 1) == 0: 2 else: 3
    let count = length div size
    var nextOutput: seq[string]
    var row: seq[ref Grid]
    for square in squares(output, size, count):
      row.add rules[square]
      if row.len == count:
        nextOutput.add row.merge()
        row.setLen(0)
    output = nextOutput

  for row in output:
    result += row.count('#')

# Read rules, build patterns and build rule table.
var rules: Rules
for line in lines("p21.data"):
  let fields = line.split(" => ")
  for (pattern, output) in expandPattern(fields[0], fields[1]):
    rules[pattern] = output


### Part 1 ###
echo "Part 1: ", rules.run(5)


### Part 2 ###
echo "Part 2: ", rules.run(18)
