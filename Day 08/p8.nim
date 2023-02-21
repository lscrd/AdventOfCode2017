import std/[strutils, sugar, tables]

type
  Inst = tuple[register: string, op: string, val: int,
               condReg: string, cond: string, condVal: int]
  Program = seq[Inst]
  Registers = Table[string, int]

proc parseInst(line: string): Inst =
  ## Parse an instruction line.
  let fields = line.split()
  result = (fields[0], fields[1], fields[2].parseInt(),
            fields[4], fields[5], fields[6].parseInt())


proc execute(registers: var Registers; inst: Inst): bool =
  ## Execute an instruction with the given registers.
  ## Return "true" if the instruction has been actually executed.
  let testVal = registers.getOrDefault(inst.condReg)
  result =
    case inst.cond
    of "==":
      testVal == inst.condVal
    of "!=":
      testVal != inst.condVal
    of "<":
      testVal < inst.condVal
    of ">":
      testVal > inst.condVal
    of "<=":
      testVal <= inst.condVal
    of ">=":
      testVal >= inst.condVal
    else:
      false

  if result:
    let val = if inst.op == "inc": inst.val else: -inst.val
    let newval = registers.getOrDefault(inst.register) + val
    registers[inst.register] = newval


# Read the program for input file.
let program = collect:
                for line in lines("p8.data"):
                  line.parseInst()


### Part 1 ###

proc run1(prog: Program): int =
  ## Run the program and return the largest value
  ## in registers after completion.
  var registers: Registers
  for inst in prog:
    discard registers.execute(inst)
  for val in registers.values:
    if val > result: result = val

echo "Part 1: ", program.run1()


### Part 2 ###

proc run2(prog: Program): int =
  ## Run the program and return the largest value
  ## encountered in registers during execution.
  var registers: Registers
  for inst in prog:
    if registers.execute(inst):
      for val in registers.values:
        if val > result: result = val

echo "Part 2: ", program.run2()
