var score, totalScore = 0       # For part 1.
var count = 0                   # For part 2.
var inGarbage, canceled = false

for ch in readFile("p9.data"):
  if inGarbage:
    if canceled:
      canceled = false
    elif ch == '>':
      inGarbage = false
    elif ch == '!':
      canceled = true
    else:
      inc count
  else:
    if ch == '{':
      inc score
      inc totalScore, score
    elif ch == '}':
      dec score
    elif ch == '<':
      inGarbage = true


### Part 1 ###
echo "Part 1: ", totalScore


### Part 2 ###
echo "Part 2: ", count
