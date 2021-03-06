//: [Previous](@previous)

import Foundation
import AdventLib
//
//
//let firstTest = """
//#######
//#.G...#
//#...EG#
//#.#.#G#
//#..G#E#
//#.....#
//#######
//"""
//
//var firstTestCave = Cave(input: firstTest, elfPower: 14)
//print(firstTestCave)
//print(firstTestCave.fight()) // 27730; 4988 with elfPower 15
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
//var cornerCaseOne = Cave(input: """
//####
//##E#
//#GG#
//####
//""")
//print(cornerCaseOne.fight()) // should take 67 rounts, score 13400
//
//var cornerCaseTwo = Cave(input: """
//#####
//#GG##
//#.###
//#..E#
//#.#G#
//#.E##
//#####
//""")
//print(cornerCaseTwo.fight()) // 71 rounds, score 13987
//
//var cornerCaseThree = Cave(input: """
//#######
//#.E..G#
//#.#####
//#G#####
//#######
//""")
//print(cornerCaseThree.fight())
//
//var cornerCaseFour = Cave(input: """
//################
//#.......G......#
//#G.............#
//#..............#
//#....###########
//#....###########
//#.......EG.....#
//################
//""")
//print(cornerCaseFour.fight()) // 18468
//
//var cornerCaseFive = Cave(input: """
//######################
//#...................E#
//#.####################
//#....................#
//####################.#
//#....................#
//#.####################
//#....................#
//###.##################
//#EG.#................#
//######################
//""")
//print(cornerCaseFive.fight()) // 13332

//var testCaseOne = Cave(input: """
//#########
//#G..G..G#
//#.......#
//#.......#
//#G..E..G#
//#.......#
//#.......#
//#G..G..G#
//#########
//""")
//print(testCaseOne.round())
//print(testCaseOne)
//print(testCaseOne.round())
//print(testCaseOne)
//print(testCaseOne.round())
//print(testCaseOne)
//
//
let url = Bundle.main.url(forResource: "day15.input", withExtension: "txt")!
let day15input = try! String(contentsOf: url)
//var day15cave = Cave(input: day15input)
//
//print(day15cave.fight()) // 232505 is too high!
//                         // 235417 is too high! (also higher than the last guess...)
//                         // 147862 isn't right...
//                         // 229950 was right!

// part 2:

var elfPower = 3
while true {
    var cave = Cave(input: day15input, elfPower: elfPower)
    let result = cave.fight()
    if result > 0 {
        print("elfpower \(elfPower) score \(result)")
        break
    } else {
        print("------------> ELF POWER_UP!!!")
        elfPower += 1
    }
}

//: [Next](@next)
