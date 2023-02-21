import std/[sets, strutils, tables]

type
  Component = tuple[a, b: int]
  CompSet = HashSet[Component]
  CompTable = Table[int, seq[Component]]

# Set of available components.
var components: CompSet
# Table mapping the number of pins to a list of components.
var compMap: CompTable

# Build "components" set and "compMap" table.
for line in lines("p24.data"):
  let fields = line.split('/')
  let f1 = fields[0].parseInt()
  let f2 = fields[1].parseInt()
  let c = (f1, f2)
  components.incl c
  compMap.mgetOrPut(f1, newSeq[Component]()).add c
  if f2 != f1:
    compmap.mgetOrPut(f2, newSeq[Component]()).add c


### Part 1 ###

proc maxStrength(start: int; compSet: CompSet): int =
  ## Find the strength of the bridge with maximum strength.
  for c in compMap[start]:
    if c in compSet:
      let (a, b) = c
      let nextStart = if a == start: b else: a
      var nextCompSet = compSet
      nextCompSet.excl c
      let s = c.a + c.b + maxStrength(nextStart, nextCompSet)
      if s > result:
        result = s

echo "Part 1: ", maxStrength(0, components)


### Part 2 ###

type LengthStrength = tuple[length, strength: int]

proc maxLength(start: int; compSet: CompSet): LengthStrength =
  ## Find the strength of the bridge with maximum (length, strength).
  for c in compMap[start]:
    if c in compSet:
      let (a, b) = c
      let nextStart = if a == start: b else: a
      var nextCompSet = compSet
      nextCompSet.excl c
      var (lg, str) = maxLength(nextStart, nextCompSet)
      lg += 1
      str += c.a + c.b
      if lg > result.length or (lg == result.length and str > result.strength):
        result = (lg, str)

echo "Part 2: ", maxLength(0, components).strength
