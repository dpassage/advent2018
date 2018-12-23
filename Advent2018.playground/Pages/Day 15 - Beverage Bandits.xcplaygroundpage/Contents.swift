//: [Previous](@previous)

import Foundation
import AdventLib


let firstTest = """
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
"""

//var firstTestCave = Cave(input: firstTest)
//print(firstTestCave)
//print(firstTestCave.fight()) // 27730
//
//var secondTestCave = Cave(input: """
//#######
//#G..#E#
//#E#E.E#
//#G.##.#
//#...#E#
//#...E.#
//#######
//""")
//
//print(secondTestCave.fight()) // 36334
//
//var thirdTestCave = Cave(input: """
//#######
//#E..EG#
//#.#G.E#
//#E.##E#
//#G..#.#
//#..E#.#
//#######
//""")
//print(thirdTestCave.fight()) // 39514
//
//var fourthTestCave = Cave(input: """
//#######
//#E.G#.#
//#.#G..#
//#G.#.G#
//#G..#.#
//#...E.#
//#######
//""")
//print(fourthTestCave.fight()) // 27755
//
//var fifthTestCave = Cave(input: """
//#######
//#.E...#
//#.#..G#
//#.###.#
//#E#G#G#
//#...#G#
//#######
//""")
//print(fifthTestCave.fight()) // 28944
//
//var sixthTestCave = Cave(input: """
//#########
//#G......#
//#.E.#...#
//#..##..G#
//#...##..#
//#...#...#
//#.G...G.#
//#.....G.#
//#########
//""")
//print(sixthTestCave.fight()) // 18740
//

let url = Bundle.main.url(forResource: "day15.input", withExtension: "txt")!
let day15input = try! String(contentsOf: url)
var day15cave = Cave(input: day15input)

print(day15cave.fight()) // 232505 is too high!

//: [Next](@next)
