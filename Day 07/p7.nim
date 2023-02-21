import std/[strmisc, strutils, tables]

type

  # Information in an input line.
  Info = tuple[name: string, weight: int, programs: seq[string]]

  # Description of a program.
  Program = ref object
    weight: int             # Program weight.
    programs: seq[string]   # List of subprograms.
    totalWeight: int        # Computed total weight.

  # Table of programs.
  Programs = Table[string, Program]

proc parseline(line: string): Info =
  ## Parse a line and return an "Info" value.
  let (head, _, tail) = line.partition(" -> ")
  let fields = head.split()
  result.name = fields[0]
  result.weight = fields[1][1..^2].parseInt()
  result.programs = if tail.len > 0: tail.split(", ") else: @[]

# Build the description from input file.
var bases: Table[string, string]
var progs: Programs
for line in lines("p7.data"):
  let info = line.parseLine()
  for program in info.programs:
    bases[program] = info.name
  if info.name notin bases:
    bases[info.name] = ""
  progs[info.name] = Program(weight: info.weight, programs: info.programs)


### Part 1 ###

var root: string
for name, base in bases.pairs:
  if base.len == 0:
    root = name
    break

echo "Part 1: ", root


### Part 2 ###

const NoValue = -1    # Default weight when not initialized.

proc computeWeight(name: string) =
  ## Compute the total weight.
  let prog = progs[name]
  for program in prog.programs:
    program.computeWeight()
  var w = prog.weight
  for p in prog.programs:
    w += progs[p].totalWeight
  prog.totalWeight = w

proc searchError(name: string; expectedWeight: int): int =
  ## Search the program in error. Return the expected weight
  ## if found or NoValue if not found.

  result = NoValue
  let prog = progs[name]

  # If program list is empty.
  if prog.programs.len == 0:
    if expectedWeight != NoValue:
      return expectedWeight
    else:
      quit "Error encountered"

  # Check weight of programs in program list.
  var val1, val2 = NoValue
  for p in prog.programs:
    let w = progs[p].totalWeight
    if val1 == NoValue:
      val1 = w
    elif val1 != w:
      if val2 == NoValue:
        val2 = w
      else:
        swap val1, val2

  # "val1" contains the right weight, "val2" the wrong one (or NoValue).
  if val2 != NoValue:
    for p in prog.programs:
      if progs[p].totalWeight == val2:
        return p.searchError(val1)
  elif expectedWeight != NoValue:
    # All weights are equal. So, we have to change the program weight.
    return prog.weight + (expectedWeight - prog.totalWeight)

root.computeWeight()
echo "Part 2: ", root.searchError(NoValue)
