import std/tables

type
  Coords = tuple[x, y: int]
  State {.pure.} = enum Clean, Weakened, Infected, Flagged
  States = Table[Coords, State]

const
  Left = [((0, 1), (-1, 0)), ((-1, 0), (0, -1)),
          ((0, -1), (1, 0)), ((1, 0), (0, 1))].toTable
  Right = [((0, 1), (1, 0)), ((1, 0), (0, -1)),
           ((0, -1), (-1, 0)), ((-1,0), (0, 1))].toTable
  Back = [((0, 1), (0, -1)), ((0, -1), (0, 1)),
          ((1, 0), (-1, 0)), ((-1, 0), (1, 0))].toTable

proc initStates(): States =
  ## Initialize the state table.
  const
    N = 25              # Starting size.
    D = (N - 1) div 2   # Delta.
  var y = D
  for line in lines("p22.data"):
    var x = -D
    for c in line:
      result[(x, y)] = if c == '#': Infected else: Clean
      inc x
    dec y

# Build the starting table of states.
var initialStates = initStates()


### Part 1 ###

proc infectionBursts1(initialStates: States; nBursts: int): int =
  ## Execute "nBursts" bursts using part 1 rules.
  ## Return the number of bursts causing an infection.

  var states = initialStates
  var direction: Coords = (0, 1)  # Up.
  var x, y = 0
  for i in 1..nBursts:
    let coords = (x, y)
    let state = states.getOrDefault(coords, Clean)
    if state == Infected:
      direction = Right[direction]
      states[coords] = Clean
    else:
      direction = Left[direction]
      states[coords] = Infected
      inc result
    x += direction[0]
    y += direction[1]

echo "Part 1: ", initialStates.infectionBursts1(10_000)


### Part 2 ###

proc infectionBursts2(initialStates: States; nBursts: int): int =
  ## Execute "nBursts" bursts using part 2 rules.
  ## Return the number of bursts causing an infection.

  var states = initialStates
  var direction: Coords = (0, 1)  # Up.
  var x, y = 0
  for i in 1..nBursts:
    let coords = (x, y)
    let state = states.getOrDefault(coords, Clean)
    var nextState: State
    case state
    of Clean:
      direction = Left[direction]
      nextState = Weakened
    of Weakened:
      nextState = Infected
      inc result
    of Infected:
      direction = Right[direction]
      nextState = Flagged
    of Flagged:
      direction = Back[direction]
      nextState = Clean
    states[coords] = nextState
    x += direction[0]
    y += direction[1]

echo "Part 1: ", initialStates.infectionBursts2(10_000_000)
