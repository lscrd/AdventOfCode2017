# Puzzle input.
const Step = 377


### Part 1 ###

var buffer = @[0]
var pos = 0
for i in 1..2017:
  pos = (pos + Step) mod i + 1
  buffer.insert(i, pos)

echo "Part 1: ", buffer[(pos + 1) mod buffer.len]


### Part 2 ###

# For this second part, no need to fill the buffer.

pos = 0
var result = 0
for i in 1..50_000_000:
  pos = (pos + Step) mod i + 1
  if pos == 1:
    result = i  # Keep last value at position 1.

echo "Part 2: ", result
