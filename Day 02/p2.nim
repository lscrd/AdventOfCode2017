import std/[sequtils, strutils]

# Read spreadsheet.
var spreadsheet: seq[seq[int]]
for row in lines("p2.data"):
  spreadsheet.add row.split().map(parseInt)


### Part 1 ###

var checkSum = 0
for row in spreadsheet:
  var min = int.high
  var max = 0
  for val in row:
    if val > max: max = val
    if val < min: min = val
  checkSum += max - min

echo "Part 1: ", checkSum


### Part 2 ###

var sum = 0
for row in spreadsheet:
  block search:
    for i in 0..<row.high:
      let n1 = row[i]
      for j in (i + 1)..row.high:
        let n2 = row[j]
        if n1 mod n2 == 0:
          sum += n1 div n2
          break search
        if n2 mod n1 == 0:
          sum += n2 div n1
          break search

echo "Part 2: ", sum
