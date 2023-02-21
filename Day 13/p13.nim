import std/[strutils, tables]

# Mapping depths to ranges.
type Ranges = OrderedTable[int, int]

var ranges: Ranges

# Build the range table.
for line in open("p13.data").lines:
  let fields = line.strip().split(": ")
  let depth = parseInt(fields[0])
  ranges[depth] = parseInt(fields[1])

proc pos(ranges: Ranges; depth, time: int): int =
  ## Return the position of scanner at given depth
  ## and at given time.
  let r = ranges[depth]
  let m = 2 * r - 2
  result = time mod m
  if result >= r:
    result = m - result


### Part 1 ###

var severity = 0
for depth in ranges.keys:
  if ranges.pos(depth, time = depth) == 0:
    severity += depth * ranges[depth]

echo "Part 1: ", severity


### Part 2 ###

proc okWithDelay(delay: int): bool =
  ## Check if the packet pass through the firewall
  ## if starting at given delay.
  result = true
  for depth in ranges.keys:
    if ranges.pos(depth, time = delay + depth) == 0:
      return false

var delay = 0
while true:
  if okWithDelay(delay):
    break
  inc delay

echo "Part 2: ", delay
