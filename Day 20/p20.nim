import std/[sets, strscans, sugar, tables]

type Coords = tuple[x, y, z: int]

var
  positions: seq[Coords]
  velocities: seq[Coords]
  accelerations: seq[Coords]

proc norm(v: Coords): int = abs(v[0]) + abs(v[1]) + abs(v[2])

for line in lines("p20.data"):
  var p, v, a: Coords
  if not line.scanf("p=<$i,$i,$i>, v=<$i,$i,$i>, a=<$i,$i,$i>",
                    p.x, p.y, p.z, v.x, v.y, v.z, a.x, a.y, a.z):
    break
  positions.add p
  velocities.add v
  accelerations.add a


### Part 1 ###

# For a given point, it exists a time t0 after which the components of velocity
# velocity have the same sign as the components of acceleration (if a component
# of acceleration is zero, the component of velocity # may be positive or negative).
# Starting for this time t0, at each step, the norm of velocity is increased by
# the norm of acceleration. Thus, when time passes, the point with the smallest
# acceleration norm will have the smallest velocity norm.
# The same reasoning is applicable for the positions. So, in the long term, the
# points with the smallest position norm (the points closest # to the origin),
# will be the points with the smallest acceleration norm.
# If there are several points with the smallest acceleration norm, we will have
# to compare their velocities at the time their components have the same sign as
# the acceleration components.
# If there exists several points with the same acceleration norm and same velocity
# norm, we will have to compare their positions at the time their components have
# the same sign as the velocity and acceleration components.
# With our input, there is only one acceleration with minimal norm, so we don't
# need to check velocities and positions.

# Search the points with minimal absolute acceleration.
var minNorm = norm(accelerations[0])
var minIdx = 0
for i in 1..accelerations.high:
  let n = norm(accelerations[i])
  if n < minNorm:
    minNorm = n
    minIdx = i
let points = collect:
              for idx in 0..accelerations.high:
                if norm(accelerations[idx]) == minNorm:
                  idx

let point = if points.len == 1:
              # We found a unique point with minimal acceleration,
              # so we have no further processing to do.
              points[0]
            else:
              quit "Found several points with minimal acceleration"

echo "Part 1: ", point


### Part 2 ###

# We simulate the particle movements during 100 rounds.
# To be rigorous, we should run the simulation until it is no longer
# possible for two particles to collide.
# But the criterion to detect this impossibility is not easy to define
# and, so, we just run the simulation long enough.

proc `+`(a, b: Coords): Coords =
  ## Add two coordinates.
  (a.x + b.x, a.y + b.y, a.z + b.z)

for _ in 1..100:

  # Find the collisions.
  var points: Table[Coords, seq[int]]
  var collisions: HashSet[Coords]
  for i, a in accelerations:
    let v = velocities[i] + a
    let p = positions[i] + v
    velocities[i] = v
    positions[i] = p
    if p in points:
      collisions.incl p
      points[p].add i
    else:
      points[p] = @[i]

  # Destroy the particles.
  var indexes: seq[int]
  for p in collisions:
      indexes.add points[p]
  for i in indexes:
    positions.del i
    velocities.del i
    accelerations.del i

echo "Part 2: ", accelerations.len
