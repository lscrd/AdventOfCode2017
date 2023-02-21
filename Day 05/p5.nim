import std/strutils

var memory: seq[int]
for line in lines("p5.data"):
  memory.add line.parseInt()
let refMem = memory   # Save initial state.


### Part 1 ###

var steps = 0
var pc = 0
while true:
  inc steps
  let offset = memory[pc]
  inc memory[pc]
  inc pc, offset
  if pc >= memory.len:
    break

echo "Part 1: ", steps


### Part 2 ###
memory = refMem   # Restore memory to initial state.
steps = 0
pc = 0
while true:
  inc steps
  let offset = memory[pc]
  if offset >= 3:
    dec memory[pc]
  else:
    inc memory[pc]
  inc pc, offset
  if pc >= memory.len:
    break

echo "Part 2: ", steps
