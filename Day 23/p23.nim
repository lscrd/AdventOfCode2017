import std/strutils

type

  # Operand.
  OpKind = enum opReg, opLit
  Operand = object
    case opKind: OpKind
    of opReg: reg: char
    of opLit: val: int

  # Instruction.
  InstCode = enum instSet = "set", instSub = "sub"
                  instMul = "mul", instJnz = "jnz",
  Inst = object
    code: InstCode
    op1, op2: Operand

  # Registers.
  Registers = array['a'..'h', int]

proc initOperand(operand: string): Operand =
  ## Initialize an operand.
  if operand.len == 1 and operand[0].isLowerAscii():
    Operand(opKind: opReg, reg: operand[0])
  else:
    Operand(opKind: opLit, val: operand.parseInt())


# Read instructions.
var instructions: seq[Inst]

for line in lines("p23.data"):
  let fields = line.strip().split(' ')
  instructions.add Inst(code: parseEnum[InstCode](fields[0]),
                        op1: initOperand(fields[1]))
  if fields.len > 2:
    instructions[^1].op2 = initOperand(fields[2])


### Part 1 ###

proc mulCount(instructions: seq[Inst]): int =
  ## Run the program and return the number of MUL instructions
  ## executed.

  var registers: Registers

  proc value(operand: Operand): int =
    ## Return the value of an operand.
    if operand.opKind == opReg: registers[operand.reg] else: operand.val

  var pc = 0
  while true:
    if pc < 0 or pc >= instructions.len:
      break
    let inst = instructions[pc]
    case inst.code
    of instSet:
      registers[inst.op1.reg] = inst.op2.value
    of instSub:
      registers[inst.op1.reg] = inst.op1.value - inst.op2.value
    of instMul:
      registers[inst.op1.reg] = inst.op1.value * inst.op2.value
      inc result
    of instJnz:
      if inst.op1.value != 0:
        inc pc, inst.op2.value
        continue
    inc pc

echo "Part 1: ", instructions.mulCount()


### Part 2 ###

proc computeRegH(): int =
  ## Compute the value in register "h" using a translation
  ## of the coprocessor program into Nim code.

  var a = 1
  var b = 65
  var c = b
  var h = 0

  if a != 0:
    b = b * 100 + 100000
    c = b + 17000

  for b in countup(b, c, 17):
    var f = 1
    for d in 2..<b:
      for e in d..(b div d):
        if d * e == b:
          f = 0
          break
      if f == 0:
        break

    if f == 0:
      h += 1

  result = h

echo "Part 2: ", computeRegH()
