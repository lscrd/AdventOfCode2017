import std/strutils

var puzzle = readFile("p1.data").strip()

### Part 1 ###

puzzle.add puzzle[0]  # To simulate circular list.
var sol = 0
for i in 0..(puzzle.len - 2):
  if puzzle[i] == puzzle[i + 1]:
    sol += ord(puzzle[i]) - ord('0')

echo "Part 1: ", sol


### Part 2 ###

let lg = puzzle.len - 1
puzzle.setLen(lg)   # Remove extra element added.
sol = 0
let delta = lg div 2
for i, d in puzzle:
  if d == puzzle[(i + delta) mod lg]:
    sol += ord(d) - ord('0')

echo "Part 2: ", sol
