import std/[algorithm, sequtils, strutils]

type
  MoveKind {.pure.} = enum Spin, Exchange, Partner
  Move = object
    case kind: MoveKind
    of Spin:
      num: int
    of Exchange:
      pos1, pos2: int
    of Partner:
      name1, name2: char

# Read dance description.
var dance: seq[Move]
for move in readFile("p16.data").strip().split(','):
  case move[0]
  of 's':
    dance.add Move(kind: Spin, num: move[1..^1].parseInt)
  of 'x':
    let positions = move[1..^1].split('/').map(parseInt)
    dance.add Move(kind: Exchange, pos1: positions[0], pos2: positions[1])
  of 'p':
    let names = move[1..^1].split('/').mapIt(it[0])
    dance.add Move(kind: Partner, name1: names[0], name2: names[1])
  else:
    quit("Wrong move type: " & $move[0])

proc doMove(line: var string; move: Move) =
  ## Execute given move.
  case move.kind
  of Spin:
    line.rotateLeft(-move.num)
  of Exchange:
    swap line[move.pos1], line[move.pos2]
  of Partner:
    let pos1 = line.find(move.name1)
    let pos2 = line.find(move.name2)
    swap line[pos1], line[pos2]


### Part 1 ###

var line = "abcdefghijklmnop"
for move in dance:
  line.doMove(move)

echo "Part 1: ", line


### Part 2 ###

# It is easy to verify that after 60 rounds, the programs are in the
# initial order. So, we have to find the order after 1000000000 mod 60 = 40
# rounds, which can be obtained very quickly.

for _ in 2..(1_000_000_000 mod 60):
  for move in dance:
    line.doMove(move)

echo "Part 2: ", line
