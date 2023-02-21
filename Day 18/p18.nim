import std/strutils

type

  # Operand.
  OpKind = enum opReg, opLit
  Operand = object
    case opKind: OpKind
    of opReg: reg: char
    of opLit: val: int

  # Instruction.
  InstCode = enum instSnd = "snd", instSet = "set"
                  instAdd = "add", instMul = "mul",
                  instMod = "mod", instRcv = "rcv",
                  instJgz = "jgz"
  Inst = object
    code: InstCode
    op1, op2: Operand

  # Registers. We reserve room for 26 registers.
  Registers = array['a'..'z', int]


proc initOperand(operand: string): Operand =
  ## Initialize an operand.
  if operand.len == 1 and operand[0].isLowerAscii():
    Operand(opKind: opReg, reg: operand[0])
  else:
    Operand(opKind: opLit, val: operand.parseInt())


# Read instructions.
var instructions: seq[Inst]

for line in lines("p18.data"):
  let fields = line.strip().split(' ')
  instructions.add Inst(code: parseEnum[InstCode](fields[0]),
                        op1: initOperand(fields[1]))
  if fields.len > 2:
    instructions[^1].op2 = initOperand(fields[2])


### Part 1 ###

proc run(instructions: seq[Inst]): int =
  ## Run the program and return the first recovered frequency.

  var registers: Registers

  proc value(operand: Operand): int =
    ## Return the value of an operand.
    if operand.opKind == opReg: registers[operand.reg] else: operand.val

  var pc = 0
  var freq = -1
  while true:
    if pc < 0 or pc >= instructions.len:
      break
    let inst = instructions[pc]

    case inst.code
    of instSnd:
      freq = inst.op1.value
    of instSet:
      registers[inst.op1.reg] = inst.op2.value
    of instAdd:
      registers[inst.op1.reg] = inst.op1.value + inst.op2.value
    of instMul:
      registers[inst.op1.reg] = inst.op1.value * inst.op2.value
    of instMod:
      registers[inst.op1.reg] = inst.op1.value mod inst.op2.value
    of instRcv:
      if inst.op1.value != 0:
        return freq   # No need to continue.
    of instJgz:
      if inst.op1.value > 0:
        inc pc, inst.op2.value
        continue

    inc pc


echo "Part 1: ", instructions.run()


### Part 2 ###

# There is no need to use a preemptive mode, so we run each program until
# it blocks waiting for data from the input queue.

type
  Queue = ref seq[int]
  Program = object
    registers: Registers
    instructions: seq[Inst]
    pc: int
    inqueue: Queue
    outqueue: Queue
    running: bool
    waiting: bool
    count: int    # Number of values sent.

proc initProgram(pid: int; instructions: seq[Inst]): Program =
  ## Initialize a program.
  result.registers['p'] = pid
  result.instructions = instructions
  result.pc = 0
  new(result.inqueue)
  result.running = true
  result.waiting = false

proc connectOutqueue(prog: var Program; queue: Queue) =
  ## Connect a queue to the output queue of a program.
  prog.outqueue = queue

proc value(prog: Program; operand: Operand): int =
  ## Return the value of an operand.
  if operand.opKind == opReg: prog.registers[operand.reg] else: operand.val


proc resume(prog: var Program) =
  ## Resume execution of a program.

  while true:
    if prog.pc < 0 or prog.pc >= prog.instructions.len:
      break
    let inst = prog.instructions[prog.pc]

    case inst.code
    of instSnd:
      prog.outqueue[].insert(prog.value(inst.op1))   # Insert at beginning.
      inc prog.count
    of instSet:
      prog.registers[inst.op1.reg] = prog.value(inst.op2)
    of instAdd:
      prog.registers[inst.op1.reg] = prog.value(inst.op1) + prog.value(inst.op2)
    of instMul:
      prog.registers[inst.op1.reg] = prog.value(inst.op1) * prog.value(inst.op2)
    of instMod:
      prog.registers[inst.op1.reg] = prog.value(inst.op1) mod prog.value(inst.op2)
    of instRcv:
      if prog.inqueue[].len != 0:
        prog.registers[inst.op1.reg] = prog.inqueue[].pop
        prog.waiting = false
      else:
        prog.waiting = true
        break   # Wait till data are available.
    of instJgz:
      if prog.value(inst.op1) > 0:
        inc prog.pc, prog.value(inst.op2)
        continue

    inc prog.pc


var prog0 = initProgram(0, instructions)
var prog1 = initProgram(1, instructions)
prog0.connectOutqueue(prog1.inqueue)
prog1.connectOutqueue(prog0.inqueue)

while prog0.running and prog1.running:
  prog0.resume()
  prog1.resume()
  # "prog1" is either waiting or not running.
  if prog0.waiting and prog0.inqueue[].len == 0:
    break   # Deadlock.

echo "Part 2: ", prog1.count
