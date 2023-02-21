import std/[sets, strutils, sugar]

type
  # Directions are represented with an enumeration.
  # Underlying integer value if chosen in order to do merge with a simple addition.
  Direction {.pure.} = enum SW = -3, NW, S, NoMove, N, SE, NE

# Couple of directions which can be merged.
const CanMerge = [(N, SE), (SE, N), (N, SW), (SW, N), (S, NE), (NE, S),
                  (S, NW), (NW, S), (SE, SW), (SW, SE), (NE, NW), (NW, NE),
                  (N, S), (S, N), (NE, SW), (SW, NE), (NW, SE), (SE, NW)].toHashSet

proc merged(d1, d2: Direction): Direction =
  ## Merge two directions.
  Direction(ord(d1) + ord(d2))

let path = collect:
            for str in readFile("p11.data").strip().split(","):
              parseEnum[Direction](str.toUpperAscii)

### Part 1 ###

proc steps(path: seq[Direction]): int =
  ## Return the number of steps required to reach the final position.
  ## This number is equal to the length of a minimal path built by
  ## merging the directions until no more merge is possible.

  var path = path
  var lg = 0
  while path.len != lg:   # While there is a change.
    var newPath: seq[Direction]
    lg = path.len
    while path.len != 0:
      let dir1 = path.pop()
      # Try to merge "dir1" with another direction.
      var merged = false
      for i in 0..path.high:
        let dir2 = path[i]
        if (dir1, dir2) in CanMerge:
          # Merge the directions.
          let newDir = merged(dir1, dir2)
          path.del(i)
          if newDir != NoMove: newPath.add newDir
          merged = true
          break
      if not merged:
        # No merge done: keep "dir1".
        newPath.add dir1
    # Continue with new path.
    path = move(newPath)

  result = path.len

echo "Part 1: ", path.steps


### Part 2 ###

# For this second part, as we need to find the length of each
# successive path, we modified the algorithm to be more efficient.

proc furthest(path: seq[Direction]): int =
  ## Return the number of steps of the furthest position reached
  ## by following the given path.

  var currPath = newSeqOfCap[Direction](path.len)
  for dir in path:
    var dir1 = dir
    while dir1 != NoMove:       # Stop if merge gives NoMove.
      var merged = false
      for i in 0..currPath.high:
        let dir2 = currPath[i]
        if (dir1, dir2) in CanMerge:
          # Merge two directions.
          dir1 = merged(dir1, dir2)
          currPath.delete(i)
          merged = true
          break   # Try with the new "dir1".
      if not merged:
        # No merge. Add the new direction.
        currPath.add dir1
        break   # Try next direction.

    if currPath.len > result:
      result = currPath.len

echo "Part 2: ", path.furthest
