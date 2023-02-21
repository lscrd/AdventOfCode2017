import std/[sets, strutils, sugar, tables]

type Banks = seq[int]

let initialState = collect:
                     for field in readFile("p6.data").strip().split():
                       field.parseInt()

iterator states(banks: Banks): Banks =
  ## Yield the successive states of the banks.
  let nbanks = banks.len
  var state = banks
  while true:
    # Find the value and index of the most occupied bank.
    let n = max(state)
    let i = state.find(n)
    # Distribute.
    state[i] = 0
    for j in 1..n:
      inc state[(i + j) mod nbanks]
    yield state


### Part 1 ###

var stateSet: HashSet[Banks]
stateSet.incl initialState
var count = 0
for state in states(initialState):
  inc count
  if state in stateSet:
    break
  stateSet.incl state

echo "Part 1: ", count


### Part 2 ###

var stateTable: Table[Banks, int]
count = 0
for state in states(initialState):
  inc count
  # Check if already encountered.
  if state in stateTable:
    dec count, stateTable[state]
    break
  # Update states.
  stateTable[state] = count

echo "Part 2: ", count
