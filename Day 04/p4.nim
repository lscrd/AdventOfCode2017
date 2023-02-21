import std/[algorithm, sequtils, sets, strutils]

var list: seq[seq[string]]
for words in lines("p4.data"):
  list.add words.split()


### Part 1 ###

var count = 0
for words in list:
  if words.len == words.toHashSet.len:
    inc count

echo "Part 1: ", count


### Part 2 ###

count = 0
for words in list:
  let sortedWords = mapIt(words, sorted(it))
  if sortedWords.len == sortedWords.toHashSet.len:
    inc count

echo "Part 2: ", count
