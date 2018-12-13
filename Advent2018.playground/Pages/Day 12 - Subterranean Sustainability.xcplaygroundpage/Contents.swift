//: [Previous](@previous)

import Foundation
import AdventLib

let testInput = """
initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
"""

var testTunnel = Tunnel(input: testInput)
print(testTunnel)
testTunnel.generations(20)
print(testTunnel.sumOfPotIndices())

let url = Bundle.main.url(forResource: "day12.input", withExtension: "txt")!
let day12input = try! String(contentsOf: url)
var day12tunnel = Tunnel(input: day12input)
day12tunnel.generations(1000)
print(day12tunnel.sumOfPotIndices())
day12tunnel.generations(1000)
print(day12tunnel.sumOfPotIndices())
day12tunnel.generations(1000)
print(day12tunnel.sumOfPotIndices())
day12tunnel.generations(1000)
print(day12tunnel.sumOfPotIndices())

let oneThousand = 103377
let perThousand = 102000
let perGenration = 102

let remainingGenerations = 50_000_000_000 - 1000
let endCount = oneThousand + (remainingGenerations * perGenration)
print(endCount)
//: [Next](@next)
