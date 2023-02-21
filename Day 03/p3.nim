import std/[strutils, tables]

type Coords = tuple[x, y: int]

let input = readFile("p3.data").strip().parseInt()


### Part 1 ###

proc coords(val: int): Coords =
  ## Return the coordinates of the given value.
  ## Value 1 is at coordinates (0, 0).

  var x, y = 0
  var n = 1
  var lim = 0

  while true:
    lim += 1
    while x < lim:
      n += 1
      x += 1
      if n == val:
        return (x, y)
    while y < lim:
      n += 1
      y += 1
      if n == val:
        return (x, y)
    while x > -lim:
      n += 1
      x -= 1
      if n == val:
        return (x, y)
    while y > -lim:
      n += 1
      y -= 1
      if n == val:
        return (x, y)

let (x, y) = input.coords
echo "Part 1: ", abs(x) + abs(y)


### Part 2 ###

type Values = Table[Coords, int]

proc newValue(values: Values; x, y: int): int =
  ## Return the value to add at position (x, y).
  for deltaX in [-1, 0, 1]:
      for deltaY in [-1, 0, 1]:
        result += values.getOrDefault((x + delta_x, y + delta_y))

proc firstValueLargerThan(n: int): int =
  ## Return the first value larger than "n".
  var values: Values = {(0, 0): 1}.toTable
  var x, y = 0
  var limit = 0
  while true:
    inc limit
    # Move rightward.
    while x < limit:
      inc x
      let val = values.newValue(x, y)
      if val > n: return val
      values[(x, y)]  = val
    # Move upward.
    while y < limit:
      inc y
      let val = values.newValue(x, y)
      if val > n: return val
      values[(x, y)] = val
    # Move leftward.
    while x > -limit:
      dec x
      let val = values.newValue(x, y)
      if val > n: return val
      values[(x, y)] = val
    # Move downward.
    while y > -limit:
      dec y
      let val = values.newValue(x, y)
      if val > n: return val
      values[(x, y)] = val

echo "Part 2: ", firstValueLargerThan(input)
