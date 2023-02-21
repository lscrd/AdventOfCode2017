import std/[sequtils, strutils]

const N = 256

type KnotHash = object
  list: array[N, int]
  lengths: seq[int]
  pos: int
  skip: int

proc initKnotHash(lengths: seq[int]): KnotHash =
  ## Initialize the Knot hash with given lengths.
  for i in 0..<N:
    result.list[i] = i
  result.lengths = lengths

proc doRound(hash: var KnotHash) =
  ## Execute a round of Knot hash.
  for lg in hash.lengths:
    for idx in 0..(lg div 2 - 1):
      let i = (hash.pos + idx) mod N
      let j = (hash.pos + lg - idx - 1) mod N
      swap hash.list[i], hash.list[j]
    hash.pos = (hash.pos + lg + hash.skip) mod N
    inc hash.skip

# Read input string.
let data = readFile("p10.data").strip()


### Part 1 ###

var lengths = data.split(',').map(parseInt)
var hash = initKnotHash(lengths)
hash.doRound()

echo "Part 1: ", hash.list[0] * hash.list[1]


### Part 2 ###

lengths = data.mapIt(ord(it))
lengths.add [17, 31, 73, 47, 23]
hash = initKnotHash(lengths)

# Apply 64 rounds.
for _ in 1..64:
  hash.doRound()

# Compute the dense hash.
var dhash: array[16, int]
for i in 0..15:
  var val = 0
  for j in 0..15:
    val = val xor hash.list[16 * i + j]
  dhash[i] = val

# Convert to a hexadecimal string.
var hexval: array[16, string]
for i in 0..15:
  hexval[i] = dhash[i].toHex(2).toLowerAscii

echo "Part 2: ", hexval.join()
