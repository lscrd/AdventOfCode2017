# Puzzle input.
const Val1 = 516
const Val2 = 190

proc count(f1, f2: proc(val: int): int; pairs: int): int =
  ## Return the number of pairs with same lowest 16 bits using
  ## the given function and the given number of pairs.
  var val1 = Val1
  var val2 = Val2
  for i in 1..pairs:
    val1 = f1(val1)
    val2 = f2(val2)
    if val1 mod 65536 == val2 mod 65536:
      inc result


### Part 1 ###

proc gen11(val: int): int = (val * 16807) mod 2_147_483_647
proc gen12(val: int): int = (val * 48271) mod 2_147_483_647

echo "Part 1: ", count(gen11, gen12, 40_000_000)


### Part 2 ###

proc gen21(val: int): int =
  result = val
  while true:
    result = (result * 16807) mod 2_147_483_647
    if (result and 3) == 0:
      break

proc gen22(val: int): int =
  result = val
  while true:
    result = (result * 48271) mod 2_147_483_647
    if (result and 7) == 0:
      break

echo "Part 2: ", count(gen21, gen22, 5_000_000)
