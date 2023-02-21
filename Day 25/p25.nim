from std/math import sum
import std/[sequtils, tables]

type State {.pure.} = enum A, B, C, D, E, F

var
  memory: Table[int, int]
  state: State = A
  pos: int = 0


### Part 1 ###

proc doStep() =
  ## Execute one step.
  case state
  of A:
    if memory.getOrDefault(pos) == 0:
      memory[pos] = 1
      inc pos
      state = B
    else:
      memory[pos] = 0
      dec pos
      state = E
  of B:
    if memory.getOrDefault(pos) == 0:
      memory[pos] = 1
      dec pos
      state = C
    else:
      memory[pos] = 0
      inc pos
      state = A
  of C:
    if memory.getOrDefault(pos) == 0:
      memory[pos] = 1
      dec pos
      state = D
    else:
      memory[pos] = 0
      inc pos
      state = C
  of D:
    if memory.getOrDefault(pos) == 0:
      memory[pos] = 1
      dec pos
      state = E
    else:
      memory[pos] = 0
      dec pos
      state = F
  of E:
    if memory.getOrDefault(pos) == 0:
      memory[pos] = 1
      dec pos
      state = A
    else:
      memory[pos] = 1
      dec pos
      state = C
  of F:
    if memory.getOrDefault(pos) == 0:
      memory[pos] = 1
      dec pos
      state = E
    else:
      memory[pos] = 1
      inc pos
      state = A


for _ in 1..12_386_363:
  doStep()

echo "Part 1: ", sum(memory.values.toSeq)
