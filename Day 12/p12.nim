import std/[sequtils, strmisc, strutils]

type
  ProgramId = int
  IdList = seq[ProgramId]

var connected: seq[IdList]

for line in lines("p12.data"):
  let (f1, _, f2) = line.partition(" <-> ")
  let num = f1.parseInt()
  let nums = f2.split(", ").map(parseInt)
  if num != connected.len:
    raise newException(ValueError, "Wrong number")
  connected.add nums


### Part 1 ###

proc count0(connected: seq[IdList]): int =
  ## Return the number of programs in group containing
  ## the program Id 0.

  var visited = repeat(false, connected.len)

  proc progCount(start: int): int =
    ## Return the number of programs connected directly or
    ## indirectly to "start".
    visited[start] = true
    result = 1
    for num in connected[start]:
      if not visited[num]:
        inc result, progCount(num)

  result = progCount(0)

echo "Part 1: ", connected.count0


### Part 2 ###

proc groupCount(connected: seq[IdList]): int =
  ## Return the number of groups for the connection list.

  var visited = repeat(false, connected.len)

  proc visit(start: int) =
    ## Mark as visited the programs directly and indirectly
    ## connected to "start".
    visited[start] = true
    for num in connected[start]:
      if not visited[num]:
        num.visit()

  for start in 0..connected.high:
    if not visited[start]:
      inc result
      start.visit()

echo "Part 2: ", connected.groupCount
